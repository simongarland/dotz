/ monitor external (.z.p*) usage of a kdb+ session to session table USAGE
\l saveorig.q
if[not`USAGE in system"a";
	USAGE:([]date:`date$();time:`time$();ms:`float$();zcmd:`symbol$();ipa:`symbol$();u:`symbol$();w:`int$();cmd:();ok:`boolean$();error:`symbol$());
	USAGE:update `s#date from USAGE]
	
busy:{update busypct:0^100*busyms%totalms from select busyms:sum ms,totalms:last ms+max time-min time by date,time.hh,u from USAGE where ok}
\d .usage
monitor:{[zcmd;endz;result;arg;startz] / record
	if[LEVEL>1;`USAGE insert (`date$startz;`time$startz;86400000*endz-startz;zcmd;.dotz.ipa .z.a;.z.u;.z.w;.dotz.txtC[zcmd;arg];1b;`)];
	result}
monitore:{[zcmd;endz;arg;error] / record error
	if[LEVEL>0;`USAGE insert (`date$endz;`time$endz;0f;zcmd;.dotz.ipa .z.a;.z.u;.z.w;.dotz.txtC[zcmd;arg];0b;`$error)];
	'error}

.z.pw:{.usage.monitor[`pw;.z.z;x[y;z];(y;"***");.z.z]}.z.pw
.z.po:{.usage.monitor[`po;.z.z;x y;y;.z.z]}.z.po
.z.pc:{.usage.monitor[`pc;.z.z;x y;y;.z.z]}.z.pc
.z.pg:{.usage.monitor[`pg;.z.z;@[x;y;.usage.monitore[`pg;.z.z;y;]];y;.z.z]}.z.pg
.z.ps:{.usage.monitor[`ps;.z.z;@[x;y;.usage.monitore[`ps;.z.z;y;]];y;.z.z]}.z.ps
.z.pi:{.usage.monitor[`pi;.z.z;@[x;y;.usage.monitore[`pi;.z.z;y;]];y;.z.z]}.z.pi
.z.ph:{.usage.monitor[`ph;.z.z;@[x;y;.usage.monitore[`ph;.z.z;y;]];y;.z.z]}.z.ph
.z.pp:{.usage.monitor[`pp;.z.z;@[x;y;.usage.monitore[`pp;.z.z;y;]];y;.z.z]}.z.pp
