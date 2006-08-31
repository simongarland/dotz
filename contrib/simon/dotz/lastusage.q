/ save last command (.z.p*) usage of a kdb+ session to .last
/ disable .z.pi as otherwise that's overwriting everything when you're trying to debug
/ (may want it for qcon though..)
\l saveorig.q
.z.pw:{if[.usage.LEVEL>1;.last.when:.z.z;.last.zcmd:`pw;.last.u:.z.u;.last.w:.z.w;.last.a:.z.a;.last.pw.x:x;.last.pw.y:y;.last.pw.z:z];x[y;z]}.z.pw
.z.po:{if[.usage.LEVEL>1;.last.when:.z.z;.last.zcmd:`po;.last.u:.z.u;.last.w:.z.w;.last.a:.z.a;.last.po.x:x;.last.po.y:y];x y}.z.po
.z.pc:{if[.usage.LEVEL>1;.last.when:.z.z;.last.zcmd:`pc;.last.u:.z.u;.last.w:.z.w;.last.a:.z.a;.last.pc.x:x;.last.pc.y:y];x y}.z.pc
.z.pg:{if[.usage.LEVEL>1;.last.when:.z.z;.last.zcmd:`pg;.last.u:.z.u;.last.w:.z.w;.last.a:.z.a;.last.pg.x:x;.last.pg.y:y];x y}.z.pg
.z.ps:{if[.usage.LEVEL>1;.last.when:.z.z;.last.zcmd:`ps;.last.u:.z.u;.last.w:.z.w;.last.a:.z.a;.last.ps.x:x;.last.ps.y:y];x y}.z.ps
/.z.pi:{if[.usage.LEVEL>1;.last.when:.z.z;.last.zcmd:`pi;.last.u:.z.u;.last.w:.z.w;.last.a:.z.a;.last.pi.x:x;.last.pi.y:y];x y}.z.pi
.z.ph:{if[.usage.LEVEL>1;.last.when:.z.z;.last.zcmd:`ph;.last.u:.z.u;.last.w:.z.w;.last.a:.z.a;.last.ph.x:x;.last.ph.y:y];x y}.z.ph
.z.pp:{if[.usage.LEVEL>1;.last.when:.z.z;.last.zcmd:`pp;.last.u:.z.u;.last.w:.z.w;.last.a:.z.a;.last.pp.x:x;.last.pp.y:y];x y}.z.pp
