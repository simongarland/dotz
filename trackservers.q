/ track active servers of a kdb+ session in session table SERVERS
\l dotz.q
if[not`SERVERS in system"a";
    SERVERS:([]name:`symbol$();hpup:`symbol$();w:`int$();hits:`int$();private:`boolean$();startp:`timestamp$();lastp:`timestamp$();endp:`timestamp$())]
SERVERHANDLES::distinct exec w from SERVERS where .dotz.liveh w
SERVERSUMMARY::select w,hpup,name,st:startp.second,et:endp.second,lt:lastp.second,hits from SERVERS

\d .servers
handlefor:{[namE] / roundrobin
    if[not cr:count r:select w,lastp from`SERVERS where .dotz.liveh w,name=namE;
        '.dotz.err(string namE)," not found"];
    if[cr>1;r:`lastp xasc r];
    W:exec first w from r;
    update lastp:.z.p,hits:1+hits from`SERVERS where w=W;
    W}
hpupfor:{[namE] / roundrobin
    if[not cr:count r:select w,lastp,hpup from`SERVERS where .dotz.liveh w,name=namE,not null hpup;
        '.dotz.err(string namE)," not found"];
    if[cr>1;r:`lastp xasc r];
    W:exec first w from r; / may be multiple instances of same hpup for different w 
    update lastp:.z.p,hits:1+hits from`SERVERS where w=W;
    exec first hpup from r}
names:{asc distinct exec name from`SERVERS where .dotz.liveh w}
unregistered:{except[key .z.W;exec w from`SERVERS]}
cleanup:{if[count w0:exec w from`SERVERS where not .dotz.livehn w;
        update lastp:.z.p,w:0Ni from`SERVERS where w in w0];
    if[AUTOCLEAN;delete from`SERVERS where not .dotz.liveh w,lastp<.z.p-.servers.RETAIN];}
/ save the list of servers currently in use to file x
savecsv:{x 0:.h.cd select name,hpup,private from`SERVERS where .dotz.liveh w;x}
/ add a new server for current session 
addnhwp:{[namE;hpuP;W;privatE]
    if[not .dotz.liveh W;'.dotz.err"invalid handle"];
    cleanup[];
    `SERVERS insert(namE;hpuP;W;0i;privatE;.z.p;.z.p;0Np);W}
addnhp:{[namE;hpuP;privatE] 
    W:@[{hopen(x;.servers.HOPENTIMEOUT)};hpuP:hsym hpuP;0Ni];
    addnhwp[namE;hpuP;W;privatE]}
addnh:addnhp[;;0b]
/ add session behind a handle
addwp:{[W;privatE]
    info:`f`h`port!(@[W;"(.z.f;.z.h;system\"p\")";((`);(`);0Ni)]);
    if[0Ni~info`port;'.dotz.err"invalid handle"];
    namE:`$last("/"vs string info`f)except enlist"";
    if[0=count namE;namE:`default];
    hpuP:hsym`$(string info`h),":",string info`port; 
    addnhwp[namE;hpuP;W;privatE]}
addw:addwp[;0b]
addnwp:{[namE;W;privatE]
    info:`h`port!(@[W;"(.z.h;system\"p\")";((`);0Ni)]);
    if[0Ni~info`port;'.dotz.err"invalid handle"];
    hpuP:hsym`$(string info`h),":",string info`port; 
    addnhwp[namE;hpuP;W;privatE]}
addnw:addnwp[;;0b]
reset:init:{delete from`SERVERS}
checkw:{{x!@[;"1b";0b]each x}exec w from`SERVERS where .dotz.liveh w,w in x}
/ load the servers from disk (csv file previously saved by savecsv)
loadcsv:{count`SERVERS insert select name,hpup,w,private,startp,lastp,hits from update hpup:hsym each hpup,w:0Ni,hits:0i,startp:.z.p,lastp:.z.p,endp:0Np from ("SSB";enlist",")0:x}
/ or grab a valid list from another task 
grab:{count`SERVERS insert update startp:.z.p,lastp:.z.p,w:0Ni,hits:0i from(x"select from SERVERS where not private")}
/ after getting new servers run retry to open connections if you don't have \t'd <retry>
retry:{update lastp:.z.p,w:@[{hopen(x;.servers.HOPENTIMEOUT)};;0Ni]each hpup from`SERVERS where not .dotz.liveh w;}
pc:{[result;W] update w:0Ni,endp:.z.p from`SERVERS where w=W;cleanup[];result}
.z.pc:{.servers.pc[x y;y]}.z.pc
.z.exit:{if[not y;.servers.savecsv`:trackservers.csv];x y;}.z.exit
\d .
h4:.servers.handlefor
hpup4:.servers.hpupfor
/ if no other timer then go fishing for lost servers every .servers.RETRY 
if[not system"t";
    .z.ts:{.servers.retry[]};
    system"t ",string .servers.RETRY]
