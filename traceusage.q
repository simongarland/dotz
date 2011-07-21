/ trace external (.z.p*) usage of a kdb+ session to console
\l saveorig.q	

\d .usage
trace:{[zcmd;endz;result;arg;startz] / record
	if[LEVEL>1;-1(" ",(string`date$startz)," ",(string`time$startz)," ms:",(string ms:86400000*endz-startz)," ",(string zcmd)," a:",(string .dotz.ipa .z.a)," u:",(string .z.u)," w:",(string .z.w)," | ",.dotz.txtc[zcmd;arg])];
	result}
tracee:{[zcmd;endz;arg;error] / record error
	if[LEVEL>0;-1("*",(string`date$endz)," ",(string`time$endz)," (error:", error,") ",(string zcmd)," a:",(string .dotz.ipa .z.a)," u:",(string .z.u)," w:",(string .z.w)," | ",.dotz.txtc[zcmd;arg])];
	'error}

/.z.pw:{.usage.trace[`pw;.z.z;x[y;z];(y;z);.z.z]}.z.pw
.z.pw:{.usage.trace[`pw;.z.z;x[y;z];(y;"***");.z.z]}.z.pw
.z.po:{.usage.trace[`po;.z.z;x y;y;.z.z]}.z.po
.z.pc:{.usage.trace[`pc;.z.z;x y;y;.z.z]}.z.pc
.z.exit:{.usage.trace[`exit;.z.z;x y;y;.z.z]}.z.exit
.z.pg:{.usage.trace[`pg;.z.z;@[x;y;.usage.tracee[`pg;.z.z;y;]];y;.z.z]}.z.pg
.z.ps:{.usage.trace[`ps;.z.z;@[x;y;.usage.tracee[`ps;.z.z;y;]];y;.z.z]}.z.ps
.z.pi:{.usage.trace[`pi;.z.z;@[x;y;.usage.tracee[`pi;.z.z;y;]];y;.z.z]}.z.pi
.z.ph:{.usage.trace[`ph;.z.z;@[x;y;.usage.tracee[`ph;.z.z;first y;]];first y;.z.z]}.z.ph
.z.pp:{.usage.trace[`pp;.z.z;@[x;y;.usage.tracee[`pp;.z.z;y;]];y;.z.z]}.z.pp
