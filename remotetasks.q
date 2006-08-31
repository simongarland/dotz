/ submit remote tasks, results get passed back to this task 
\l saveorig.q	
.tasks.RETAIN:5%24*60 / 5 minutes
.tasks.AUTOCLEAN:1b / cleanup old records when fetching results 
t:@[value;"\\l remotetasks.custom.q";::]      

if[not`TASKS in system"a";
	.tasks.COUNTER:0;
	.tasks.LASTGRP:10000;
	TASKS:([nr:`int$()]grp:`int$();startz:`datetime$();endz:`datetime$();w:`int$();ipa:`symbol$();status:`symbol$();expr:();result:())]
\d .taskgrps
grps:{distinct exec grp from value`TASKS}
nrsfor:{exec nr from value`TASKS where grp in x}
grp:{[grP;nR] update grp:grP from`TASKS where nr in nR;nR}
nextgrp:{:.tasks.LASTGRP+:1}
\d .tasks
k)d2:{!/.+x} / dictionary from 2 columns

xeq:{(neg .z.w)$[first result:@[{(1b;value x)};y;{(0b;x)}];(`.tasks.complete;x;1_ result);(`.tasks.fail;x;1_ result)]}
submitg:{[w;grp;expr] / ~ w expr
	nr:COUNTER+:1;w:abs w;
	`TASKS insert`nr`grp`startz`endz`w`ipa`status`expr`result!(nr;grp;.z.z;0Nz;w;`;`pending;expr;());
	(neg w)(xeq;nr;expr);nr}    
submit:{[w;expr] submitg[w;.taskgrps.nextgrp[];expr]}
results:{r:d2 select nr,result from value`TASKS where status=`complete,nr in x;
	if[AUTOCLEAN; delete from`TASKS where status<>`pending,endz<.z.z-.tasks.RETAIN];
	r}
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
complete:{[nR;resulT]update result:resulT,endz:.z.z,status:`complete,ipa:.dotz.ipa .z.a from`TASKS where nr=nR;}
fail:{[nR;resulT]update result:resulT,status:`fail,endz:.z.z,ipa:.dotz.ipa .z.a from`TASKS where status=`pending,nr=nR;}

closew:{update status:`fail,endz:.z.z from`TASKS where status=`pending,w in x;x}
pc:{[result;arg] closew arg;update w:0 from`TASKS where w=arg;result}

\d .dotz
.z.pc:{.tasks.pc[x y;y]}.z.pc
