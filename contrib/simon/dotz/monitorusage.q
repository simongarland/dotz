/ monitor external (.z.p*) usage of a kdb+ session to session table USAGE
\l saveorig.q
if[not`USAGE in system"a";
	USAGE:([]date:`date$();time:`time$();ms:`float$();mdelta:`int$();zcmd:`symbol$();ipa:`symbol$();u:`symbol$();w:`int$();cmd:();ok:`boolean$();error:`symbol$());
	USAGE:update `s#date from USAGE]
	
busy:{update busypct:0^100*busyms%totalms from select busyms:sum ms,totalms:last ms+max time-min time by date,time.hh,u from USAGE where ok}
\d .usage
monitor:{[zcmd;endw;endz;result;arg;startz;startw] / record
	if[LEVEL>1;`USAGE insert (`date$startz;`time$startz;86400000*endz-startz;floor .001*endw-startw;zcmd;.dotz.ipa .z.a;.z.u;.z.w;.dotz.txtC[zcmd;arg];1b;`)];
	result}
monitore:{[zcmd;endz;arg;error] / record error
	if[LEVEL>0;`USAGE insert (`date$endz;`time$endz;0f;0;zcmd;.dotz.ipa .z.a;.z.u;.z.w;.dotz.txtC[zcmd;arg];0b;`$error)];
	'error}

.z.pw:{.usage.monitor[`pw;0j;.z.z;x[y;z];(y;"***");.z.z;0]}.z.pw
.z.po:{.usage.monitor[`po;0j;.z.z;x y;y;.z.z;0]}.z.po
.z.pc:{.usage.monitor[`pc;0j;.z.z;x y;y;.z.z;0]}.z.pc
.z.pg:{.usage.monitor[`pg;.dotz.fsw[];.z.z;@[x;y;.usage.monitore[`pg;.z.z;y;]];y;.z.z;.dotz.fsw[]]}.z.pg
.z.ps:{.usage.monitor[`ps;.dotz.fsw[];.z.z;@[x;y;.usage.monitore[`ps;.z.z;y;]];y;.z.z;.dotz.fsw[]]}.z.ps
.z.pi:{.usage.monitor[`pi;.dotz.fsw[];.z.z;@[x;y;.usage.monitore[`pi;.z.z;y;]];y;.z.z;.dotz.fsw[]]}.z.pi
.z.ph:{.usage.monitor[`ph;.dotz.fsw[];.z.z;@[x;y;.usage.monitore[`ph;.z.z;y;]];y;.z.z;.dotz.fsw[]]}.z.ph
.z.pp:{.usage.monitor[`pp;.dotz.fsw[];.z.z;@[x;y;.usage.monitore[`pp;.z.z;y;]];y;.z.z;.dotz.fsw[]]}.z.pp
