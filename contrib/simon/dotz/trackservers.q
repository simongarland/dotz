/ track active servers of a kdb+ session in session table SERVERS
\l saveorig.q
if[not`SERVERS in system"a";
	SERVERS:([]name:`symbol$();hpup:`symbol$();w:`int$();hits:`int$();private:`boolean$();lastz:`datetime$())]
	
\d .servers
h4:handlefor:{[namE] / roundrobin
	if[not cr:count r:select w,lastz from value`SERVERS where w>0,name=namE;
		'(`)sv namE,`not`available];
	if[cr>1;r:`lastz xasc r];
	W:exec first w from r;
	update lastz:.z.z,hits:1+hits from`SERVERS where w=W;
	W}
names:{asc distinct exec name from value`SERVERS where w>0}
handles:{distinct exec w from value`SERVERS where w>0}
down:{distinct select name,hpup from value`SERVERS where null w}
up:{distinct select name,hpup from value`SERVERS where w>0}
self:{distinct select name,hpup from value`SERVERS where w=0}
/ save the list of servers currently in use to file x
savecsv:{x 0:.h.cd select name,hpup,private from value`SERVERS;x}
/ force only one of each active name+hpup
onlyone:{allw:exec w from value`SERVERS;okw:0 0N,exec w from select last w by name,hpup from value`SERVERS where w>0;
	dupw:allw except okw; delete from`SERVERS where w in dupw; @[hclose;;0]each dupw;
	neg count dupw}
/ add a new server for current session 
addnhwp:{[namE;hpuP;W;privatE] `SERVERS insert(namE;hpuP;W;0;privatE;.z.z);W}
addnhp:{[namE;hpuP;privatE] 
	W:@[{hopen(x;.servers.HOPENTIMEOUT)};hpuP:hsym hpuP;0N];
	addnhwp[namE;hpuP;W;privatE]}
addnh:addnhp[;;0b]
/ add session behind a handle
addwp:{[W;privatE]
	info:`f`h`port!(@[W;"(.z.f;.z.h;system\"p\")";((`);(`);0N)]);
	if[$[0N~info`port;1b;(`)~info`f];'`unknown];
	namE:`$last("/"vs string info`f)except enlist""; 
	hpuP:hsym`$(string info`h),":",string info`port; 
	addnhwp[namE;hpuP;W;privatE]}
addw:addwp[;0b]
addnwp:{[namE;W;privatE]
	info:`h`port!(@[W;"(.z.h;system\"p\")";((`);0N)]);
	if[0N~info`port;'`unknown];
	hpuP:hsym`$(string info`h),":",string info`port; 
	addnhwp[namE;hpuP;W;privatE]}
addnw:addnwp[;;0b]
/ clear table, doesn't close the handles - do reset close handles[] for that
reset:init:{delete from`SERVERS}
/ clean up dead handles
clean:{delete from`SERVERS where null w;}
/ close open handles - watchout if you have a \t'd <retry>!
close:{update lastz:.z.z,w:@[{hclose x;0N};;0N]each w from`SERVERS where w>0,w in x;x}
/ load the servers from disk (csv file previously saved by savecsv)
loadcsv:{count`SERVERS insert select name,hpup,w,private,lastz from update hpup:hsym each hpup,w:0N,hits:0,lastz:.z.z from ("SSB";enlist",")0:x}
/ or grab a valid list from another task 
grab:{count`SERVERS insert update lastz:.z.z,w:0N from(x"select from SERVERS where not private")}
/ after getting new servers run retry to open connections if you don't have \t'd <retry>
retry:{update lastz:.z.z,w:@[{hopen(x;.servers.HOPENTIMEOUT)};;0N]peach hpup from`SERVERS where null w;}
pc:{[result;arg] update w:0N,lastz:.z.z from`SERVERS where w=arg;result}
.z.pc:{.servers.pc[x y;y]}.z.pc
\d .
if[not count select w from SERVERS where w=0,name=`servers;
	.servers.addnhwp[`servers;hsym`$":"sv string(.dotz.ipa .z.a;system"p");0;1b]]
/ if no other timer then go fishing for lost servers every 5 minutes 
if[not system"t";
	.z.ts:{.servers.retry[]};
	system"t ",string .servers.RETRY]
