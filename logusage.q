/ log external (.z.p* & .z.exit) usage of a kdb+ session to .usage.FILE
/ use <loadusage.q> to load and create table USAGE
\l saveorig.q
@[value;"\\l logusage.custom.q";::];

\d .usage
logDirect:{[id;zcmd;endz;result;arg;startz] / log complete action
	if[LEVEL>1;H enlist(`LD;`USAGE;(id;.z.i;startz;endz;zcmd;.z.a;.z.u;.z.w;.dotz.txtC[zcmd;arg];1b;`;enlist arg))];result}
logBefore:{[id;zcmd;arg;startz] / log non-time info before execution
	if[LEVEL>1;H enlist(`LB;`USAGE;(id;.z.i;startz;0Nz;zcmd;.z.a;.z.u;.z.w;.dotz.txtC[zcmd;arg];0b;`;enlist arg))];}
logAfter:{[id;endz;result;startz] / fill in time info after execution 
	if[LEVEL>1;H enlist(`LA;`USAGE;(id;1b;startz;endz))];result}
logError:{[id;endz;error] / fill in error info
	if[LEVEL>0;H enlist(`LE;`USAGE;(id;0b;endz;`$error))];'error}
/ if logfile doesn't exist create and initialise it
if[()~key FILE;.[FILE;();:;()]]
H:hopen FILE;HJ:hcount FILE
nextid:{:HJ+:1}

p0:{[x;y;z;a]logDirect[nextid[];`pw;.z.z;y[z;a];(z;"***");.z.z]}
p1:{logDirect[nextid[];x;.z.z;y z;z;.z.z]}
p2:{id:nextid[];logBefore[id;x;z;.z.z];logAfter[id;.z.z;@[y;z;logError[id;.z.z;]];.z.z]}

.z.pw:p0[`pw;.z.pw;;]
.z.po:p1[`po;.z.po;];.z.pc:p1[`pc;.z.pc;]
.z.exit:p2[`exit;.z.exit;];.z.pg:p2[`pg;.z.pg;];.z.ps:p2[`ps;.z.ps;];.z.pi:p2[`pi;.z.pi;];.z.ph:p2[`ph;.z.ph;];.z.pp:p2[`pp;.z.pp;]
 
