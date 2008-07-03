/ log external (.z.p* & .z.exit) usage of a kdb+ session to .usage.FILE
/ use <loadusage.q> to load and create table USAGE
\l saveorig.q
@[value;"\\l logusage.custom.q";::];

\d .usage
logDirect:{[id;zcmd;endw;endz;result;arg;startz;startw] / log complete action
	if[LEVEL>1;H enlist(`LD;`USAGE;(id;startz;endz;startw;endw;zcmd;.z.a;.z.u;.z.w;.dotz.txtC[zcmd;arg];1b;`;enlist arg))];result}
logBefore:{[id;zcmd;arg;startz] / log non-time/space info before execution
	if[LEVEL>1;H enlist(`LB;`USAGE;(id;startz;0Nz;0j;0j;zcmd;.z.a;.z.u;.z.w;.dotz.txtC[zcmd;arg];0b;`;enlist arg))];}
logAfter:{[id;endw;endz;result;startz;startw] / fill in time/space info after execution 
	if[LEVEL>1;H enlist(`LA;`USAGE;(id;1b;startz;endz;startw;endw))];result}
logError:{[id;endz;error] / fill in error info
	if[LEVEL>0;H enlist(`LE;`USAGE;(id;0b;endz;`$error))];'error}
/ if logfile doesn't exist create and initialise it
if[()~key FILE;.[FILE;();:;()]]
H:hopen FILE;HJ:hcount FILE
nextid:{:.usage.HJ+:1}

p0:{[x;y;z;a]logDirect[nextid[];`pw;0j;.z.z;y[z;a];(z;"***");.z.z;0j]}
p1:{logDirect[nextid[];x;0j;.z.z;y z;z;.z.z;0j]}
p2:{id:nextid[];logBefore[id;x;z;.z.z];logAfter[id;.dotz.fsw[];.z.z;@[y;z;logError[id;.z.z;]];.z.z;.dotz.fsw[]]}

.z.pw:p0[`pw;.z.pw;;]
.z.po:p1[`po;.z.po;];.z.pc:p1[`pc;.z.pc;];.z.exit:p1[`exit;.z.exit;]
.z.pg:p2[`pg;.z.pg;];.z.ps:p2[`ps;.z.ps;];.z.pi:p2[`pi;.z.pi;];.z.ph:p2[`ph;.z.ph;];.z.pp:p2[`pp;.z.pp;]
 
