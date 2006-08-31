/ log external (.z.p*) usage of a kdb+ session to FILE
/ use <loadusage.q> to load and create table USAGE
\l saveorig.q
@[value;"\\l logusage.custom.q";::];
\d .usage
track:{[zcmd;endz;result;arg;startz] / record
	if[LEVEL>1;H enlist(`LOADUSAGE;`USAGE;(startz;endz;zcmd;.z.a;.z.u;.z.w;.dotz.txt[zcmd;arg];1b;`))];
	result}
tracke:{[zcmd;endz;arg;error] / record error
	if[LEVEL>0;H enlist(`LOADUSAGE;`USAGE;(endz;endz;zcmd;.z.a;.z.u;.z.w;.dotz.txt[zcmd;arg];0b;`$error))];
	'error}
\d .dotz
TXTW:250
/ if file doesn't exist create and initialise it
if[()~key .usage.FILE;.[.usage.FILE;();:;()]]
.usage.H:hopen .usage.FILE
.z.pw:{.usage.track[`pw;.z.z;x[y;z];(y;"***");.z.z]}.z.pw
.z.po:{.usage.track[`po;.z.z;x y;y;.z.z]}.z.po
.z.pc:{.usage.track[`pc;.z.z;x y;y;.z.z]}.z.pc
.z.pg:{.usage.track[`pg;.z.z;@[x;y;.usage.tracke[`pg;.z.z;y;]];y;.z.z]}.z.pg
.z.ps:{.usage.track[`ps;.z.z;@[x;y;.usage.tracke[`ps;.z.z;y;]];y;.z.z]}.z.ps
.z.pi:{.usage.track[`pi;.z.z;@[x;y;.usage.tracke[`pi;.z.z;y;]];y;.z.z]}.z.pi
.z.ph:{.usage.track[`ph;.z.z;@[x;y;.usage.tracke[`ph;.z.z;y;]];y;.z.z]}.z.ph
.z.pp:{.usage.track[`pp;.z.z;@[x;y;.usage.tracke[`pp;.z.z;y;]];y;.z.z]}.z.pp
