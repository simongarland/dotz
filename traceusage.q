/ trace external (.z.p*) usage of a kdb+ session to console
\l saveorig.q	

\d .usage
trace:{[zcmd;endp;result;arg;startp] / record
    if[LEVEL>1;-1(" ",(string`date$startp)," ",(string`time$startp)," ms:",(string ms:0.000001*endp-startp)," ",(string zcmd)," a:",(string .dotz.ipa .z.a)," u:",(string .z.u)," w:",(string .z.w)," | ",.dotz.txtc[zcmd;arg])];
	result}
tracee:{[zcmd;endp;arg;error] / record error
	if[LEVEL>0;-1("*",(string`date$endp)," ",(string`time$endp)," (error:", error,") ",(string zcmd)," a:",(string .dotz.ipa .z.a)," u:",(string .z.u)," w:",(string .z.w)," | ",.dotz.txtc[zcmd;arg])];
	'error}

/.z.pw:{.usage.trace[`pw;.z.p;x[y;z];(y;z);.z.p]}.z.pw
.z.pw:{.usage.trace[`pw;.z.p;x[y;z];(y;"***");.z.p]}.z.pw
.z.po:{.usage.trace[`po;.z.p;x y;y;.z.p]}.z.po
.z.pc:{.usage.trace[`pc;.z.p;x y;y;.z.p]}.z.pc
.z.exit:{.usage.trace[`exit;.z.p;x y;y;.z.p]}.z.exit
.z.pg:{.usage.trace[`pg;.z.p;@[x;y;.usage.tracee[`pg;.z.p;y;]];y;.z.p]}.z.pg
.z.ps:{.usage.trace[`ps;.z.p;@[x;y;.usage.tracee[`ps;.z.p;y;]];y;.z.p]}.z.ps
.z.pi:{.usage.trace[`pi;.z.p;@[x;y;.usage.tracee[`pi;.z.p;y;]];y;.z.p]}.z.pi
.z.ph:{.usage.trace[`ph;.z.p;@[x;y;.usage.tracee[`ph;.z.p;first y;]];first y;.z.p]}.z.ph
.z.pp:{.usage.trace[`pp;.z.p;@[x;y;.usage.tracee[`pp;.z.p;y;]];y;.z.p]}.z.pp
.z.ws:{.usage.trace[`ws;.z.p;@[x;y;.usage.tracee[`ws;.z.p;y;]];y;.z.p]}.z.ws
