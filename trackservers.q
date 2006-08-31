/ track active servers of a kdb+ session in session table SERVERS
\l saveorig.q
if[not`SERVERS in system"a";
	SERVERS:([]name:`symbol$();hpup:`symbol$();w:`int$();private:`boolean$();lastz:`datetime$())]
\d .servers
handlefor:{[namE] / roundrobin
	if[not cr:count r:select w,lastz from value`SERVERS where w>0,name=namE;
		'(`)sv namE,`not`available];
	W:exec first w from `lastz xasc r;
	update lastz:.z.z from`SERVERS where w=W;
	W}
names:{asc distinct exec name from value`SERVERS where w>0}
handles:{distinct exec w from value`SERVERS where w>0}
down:{distinct select name,hpup from value`SERVERS where w=-1}
up:{distinct select name,hpup from value`SERVERS where w>0}
self:{distinct select name,hpup from value`SERVERS where w=0}
/ save the list of servers currently in use to file x
savecsv:{x 0:.h.cd select name,hpup,private from value`SERVERS;x}
/ force only one of each active name+hpup
onlyone:{allw:exec w from value`SERVERS;okw:0 -1,exec w from select last w by name,hpup from value`SERVERS where w>0;
	dupw:allw except okw; delete from`SERVERS where w in dupw; @[hclose;;0]each dupw;
	neg count dupw}
/ add a new server for current session 
addp:{[namE;hpuP;privatE] `SERVERS insert(namE;hpuP;W:@[hopen;hpuP:hsym hpuP;-1];privatE;.z.z);W}
add:addp[;;0b]
/ clear table, doesn't close the handles - do reset close handles[] for that
reset:init:{delete from`SERVERS}
/ close open handles - watchout if you have a \t'd <retry>!
close:{update lastz:.z.z,w:@[{hclose x;-1};;-1]each w from`SERVERS where w>0,w in x;x}
/ load the servers from disk (csv file previously saved by savecsv)
loadcsv:{count`SERVERS insert select name,hpup,w,private,lastz from update hpup:hsym each hpup,w:-1,lastz:.z.z from ("SSB";enlist",")0:x}
/ or grab a valid list from another task 
grab:{count`SERVERS insert update lastz:.z.z,w:-1 from(x"delete from `SERVERS where private")}
/ after getting new servers run retry to open connections if you don't have \t'd <retry>
retry:{update lastz:.z.z,w:@[hopen;;-1]peach hpup from`SERVERS where w=-1;}
pc:{[result;arg] update w:-1,lastz:.z.z from`SERVERS where w=arg;result}
\d .dotz
.z.pc:{.servers.pc[x y;y]}.z.pc
\d .
if[not count select w from SERVERS where w=0,name=`servers;
	.servers.add[`servers;hsym`$":"sv string(.z.h;system"p")]]
/ if no other timer then go fishing for lost servers every 5 minutes 
if[not system"t";
	.z.ts:{.servers.retry[]};
	system"t ",string prd 5 60 1000]
