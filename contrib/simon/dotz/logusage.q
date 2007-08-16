/ log external (.z.p*) usage of a kdb+ session to FILE
/ use <loadusage.q> to load and create table USAGE
\l saveorig.q
@[value;"\\l logusage.custom.q";::];

\d .usage
track:{[zcmd;endw;endz;result;arg;startz;startw] / record
	if[LEVEL>1;H enlist(`LOADUSAGE;`USAGE;(startz;endz;startw;endw;zcmd;.z.a;.z.u;.z.w;.dotz.txtC[zcmd;arg];1b;`))];
	result}
tracke:{[zcmd;endz;arg;error] / record error
	if[LEVEL>0;H enlist(`LOADUSAGE;`USAGE;(endz;endz;0j;0j;zcmd;.z.a;.z.u;.z.w;.dotz.txtC[zcmd;arg];0b;`$error))];
	'error}
/ if file doesn't exist create and initialise it
if[()~key .usage.FILE;.[.usage.FILE;();:;()]]
.usage.H:hopen .usage.FILE
.z.pw:{.usage.track[`pw;0j;.z.z;x[y;z];(y;"***");.z.z]}.z.pw
.z.po:{.usage.track[`po;0j;.z.z;x y;y;.z.z]}.z.po
.z.pc:{.usage.track[`pc;0j;.z.z;x y;y;.z.z]}.z.pc
.z.pg:{.usage.track[`pg;.dotz.fsw[];.z.z;@[x;y;.usage.tracke[`pg;.z.z;y;]];y;.z.z;.dotz.fsw[]]}.z.pg
.z.ps:{.usage.track[`ps;.dotz.fsw[];.z.z;@[x;y;.usage.tracke[`ps;.z.z;y;]];y;.z.z;.dotz.fsw[]]}.z.ps
.z.pi:{.usage.track[`pi;.dotz.fsw[];.z.z;@[x;y;.usage.tracke[`pi;.z.z;y;]];y;.z.z;.dotz.fsw[]]}.z.pi
.z.ph:{.usage.track[`ph;.dotz.fsw[];.z.z;@[x;y;.usage.tracke[`ph;.z.z;y;]];y;.z.z;.dotz.fsw[]]}.z.ph
.z.pp:{.usage.track[`pp;.dotz.fsw[];.z.z;@[x;y;.usage.tracke[`pp;.z.z;y;]];y;.z.z;.dotz.fsw[]]}.z.pp
