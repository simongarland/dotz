/ submit remote tasks and local tasks - synchronously or asynchronously,
/ results passed back to TASKS in this task 
/ rxa - Remote eXecute Async
/ rxs - Remote eXecute Sync
/ lxa - Local eXecute Async
/ lxs - Local eXecute Sync

\l saveorig.q	
@[value;"\\l remotetasks.custom.q";::];      
if[not`TASKS in system"a";
	.tasks.LASTNR:10000;
	TASKS:([nr:`int$()]grp:`symbol$();id:`int$();startz:`datetime$();endz:`datetime$();w:`int$();ipa:`symbol$();status:`symbol$();expr:();result:())]
TASKNRS::exec nr from TASKS
TASKGRPS::distinct exec grp from TASKS

\d .tasks
grps:{distinct exec grp from value`TASKS}
nrsfor:{exec nr from value`TASKS where grp in x}
grp:{[grP;nR] update grp:grP from`TASKS where nr in nR;nR}
nextnr:{:.tasks.LASTNR+:1}
k)d2:{!/.+x} / dictionary from 2 columns

rxagXEQ:{(neg .z.w)$[first result:@[{(1b;enlist value x)};y;{(0b;enlist x)}];(`.tasks.complete;x;1_ result);(`.tasks.fail;x;1_ result)]}
rxsgXEQ:{$[first result:@[{(1b;enlist value x)};y;{(0b;enlist x)}];(`.tasks.complete;x;1_ result);(`.tasks.fail;x;1_ result)]}
lxagXEQ:{(neg .z.w)(`.tasks.localexecute;x)}
lxsgXEQ:{localexecute x}

addtask:{[nr;w;grp;id;expr]
	`TASKS insert`nr`grp`id`startz`endz`w`ipa`status`expr`result!(nr;grp;id;.z.z;0Nz;w;`;`pending;expr;());nr}

rxag:{[w;grp;id;expr] / ~ w expr
	addtask[nr:nextnr[];w:abs w;grp;id;expr];
	(neg w)(rxagXEQ;nr;expr);nr}    
rxa:{[w;expr] rxag[w;`;0;expr]}

rxsg:{[w;grp;id;expr] / ~ w expr
	addtask[nr:nextnr[];w:abs w;grp;id;expr];
	value w(rxsgXEQ;nr;expr);nr}    
rxs:{[w;expr] rxsg[w;`;0;expr]}

lxag:{[w;grp;id;expr] / ~ w expr
	addtask[nr:nextnr[];w:abs w;grp;id;expr];
	(neg w)(lxagXEQ;nr);nr}    
lxa:{[w;expr] lxag[w;`;0;expr]}

lxsg:{[w;grp;id;expr] / ~ w expr
	addtask[nr:nextnr[];w:abs w;grp;id;expr];
	value(lxsgXEQ;nr);nr}    
lxs:{[w;expr] lxsg[w;`;0;expr]}

results:{r:d2 select nr,result from value`TASKS where status=`complete,nr in x;
	if[AUTOCLEAN; delete from`TASKS where status<>`pending,endz<.z.z-.tasks.RETAIN];r}
resultsf:{$[all x in completed[];results x;'`missing.tasks]} / force results

ms:{d2 select nr,86400000*endz-startz from value`TASKS where nr in x}
status:{d2 select nr,status from value`TASKS where nr in x}
grpsfor:{d2 select nr,grp from value`TASKS where nr in x}
nrs:{exec nr from value`TASKS}
completed:{exec nr from value`TASKS where status=`complete}
failed:{exec nr from value`TASKS where status=`fail}
cancelled:{exec nr from value`TASKS where status=`cancel}
pending:{exec nr from value`TASKS where status=`pending}

chasew:{@[;"1b";0b]peach distinct x;x}
chase:{chasew exec w from value`TASKS where nr in x,w>0;x}
flush:{hclose each distinct exec w from value`TASKS where nr in x,w>0;x}
cancel:{update status:`cancel,endz:.z.z from`TASKS where status=`pending,nr in x;x}
reset:{delete from`TASKS;}
clean:{delete from`TASKS where status<>`pending,endz<.z.z-.tasks.RETAIN;}

/ callbacks

closew:{update status:`fail,endz:.z.z from`TASKS where status=`pending,w in x;x}
pc:{[result;arg] closew arg;update w:0 from`TASKS where w=arg;result}

saveonexit:{[result;arg] if[AUTOCLEAN;.tasks.clean[]];if[count value`TASKS;(`$":T",(-3_(string .z.z)except"T:."),".",(string .z.i),".csv")0:","0:update pid:.z.i from select nr,grp,id,startz,ms:86400000*endz-startz from value`TASKS where status=`complete];result}
saveonexit:{[result;arg] result} / by default don't do anything interesting

\d .
.tasks.complete:{[nR;resulT] TASKS::update result:resulT,endz:.z.z,status:`complete,ipa:.dotz.ipa .z.a from TASKS where nr=nR;}
.tasks.fail:{[nR;resulT] TASKS::update result:resulT,endz:.z.z,status:`fail,ipa:.dotz.ipa .z.a from TASKS where status=`pending,nr=nR;}
.tasks.localexecute:{[nR] 
	if[not null ti:first exec i from TASKS where nr=nR,status=`pending;
		r:@[{(1b;enlist value x)};first exec expr from TASKS where i=ti;{(0b;enlist x)}];
		statuS:`fail`complete[first r];	
		TASKS::update result:1_r,endz:.z.z,status:statuS,ipa:.dotz.ipa .z.a from TASKS where i=ti];}

.z.pc:{.tasks.pc[x y;y]}.z.pc
.z.exit:{.tasks.saveonexit[x y;y]}.z.exit                                           
