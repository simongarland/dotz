/ trace external (.z.p*) usage of a kdb+ session to console
\l saveorig.q	

\d .usage
red:$[.z.o in `w32`w64;{x};{"\033[37;41m",x,"\033[0m"}]
blueif:$[.z.o in `w32`w64;{x};{$[x;"\033[37;44m",y,"\033[0m";y]}]
trace:{[zcmd;endw;endz;result;arg;startz;startw] / record
	if[LEVEL>1;-1 blueif[ms>.usage.EXPENSIVE](" ",(string`date$startz)," ",(string`time$startz)," ms:",(string ms:86400000*endz-startz)," m+:",(string floor .001*endw-startw),"K ",(string zcmd)," a:",(string .dotz.ipa .z.a)," u:",(string .z.u)," w:",(string .z.w)," ",.dotz.txtc[zcmd;arg])];
	result}
tracee:{[zcmd;endz;arg;error] / record error
	if[LEVEL>0;-1 red("*",(string`date$endz)," ",(string`time$endz)," (error:", error,") ",(string zcmd)," a:",(string .dotz.ipa .z.a)," u:",(string .z.u)," w:",(string .z.w)," ",.dotz.txtc[zcmd;arg])];
	'error}

/.z.pw:{.usage.trace[`pw;.z.z;x[y;z];(y;z);.z.z]}.z.pw
.z.pw:{.usage.trace[`pw;0j;.z.z;x[y;z];(y;"***");.z.z;0]}.z.pw
.z.po:{.usage.trace[`po;0j;.z.z;x y;y;.z.z;0]}.z.po
.z.pc:{.usage.trace[`pc;0j;.z.z;x y;y;.z.z;0]}.z.pc
.z.pg:{.usage.trace[`pg;.dotz.fsw[];.z.z;@[x;y;.usage.tracee[`pg;.z.z;y;]];y;.z.z;.dotz.fsw[]]}.z.pg
.z.ps:{.usage.trace[`ps;.dotz.fsw[];.z.z;@[x;y;.usage.tracee[`ps;.z.z;y;]];y;.z.z;.dotz.fsw[]]}.z.ps
.z.pi:{.usage.trace[`pi;.dotz.fsw[];.z.z;@[x;y;.usage.tracee[`pi;.z.z;y;]];y;.z.z;.dotz.fsw[]]}.z.pi
.z.ph:{.usage.trace[`ph;.dotz.fsw[];.z.z;@[x;y;.usage.tracee[`ph;.z.z;first y;]];first y;.z.z;.dotz.fsw[]]}.z.ph
.z.pp:{.usage.trace[`pp;.dotz.fsw[];.z.z;@[x;y;.usage.tracee[`pp;.z.z;y;]];y;.z.z;.dotz.fsw[]]}.z.pp
