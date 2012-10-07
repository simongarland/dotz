/ save last command (.z.p*) usage of a kdb+ session to .last
/ disable .z.pi as otherwise that's overwriting everything when you're trying to debug
/ (may want it for qcon though..)
\l saveorig.q

.z.pw:{r:x[y;z];if[.usage.LEVEL>1;.last.pw.when:.z.p;.last.zcmd:`pw;.last.pw.u:.z.u;.last.pw.w:.z.w;.last.pw.a:.z.a;.last.pw.x:x;.last.pw.y:y;.last.pw.z:z;.last.pw.r:r];r}.z.pw
.z.po:{r:x y;if[.usage.LEVEL>1;.last.po.when:.z.p;.last.zcmd:`po;.last.po.u:.z.u;.last.po.w:.z.w;.last.po.a:.z.a;.last.po.x:x;.last.po.y:y;.last.po.r:r];r}.z.po
.z.pc:{r:x y;if[.usage.LEVEL>1;.last.pc.when:.z.p;.last.zcmd:`pc;.last.pc.u:.z.u;.last.pc.w:.z.w;.last.pc.a:.z.a;.last.pc.x:x;.last.pc.y:y;.last.pc.r:r];r}.z.pc
.z.pg:{r:x y;if[.usage.LEVEL>1;.last.pg.when:.z.p;.last.zcmd:`pg;.last.pg.u:.z.u;.last.pg.w:.z.w;.last.pg.a:.z.a;.last.pg.x:x;.last.pg.y:y;.last.pg.r:r];r}.z.pg
.z.ps:{r:x y;if[.usage.LEVEL>1;.last.ps.when:.z.p;.last.zcmd:`ps;.last.ps.u:.z.u;.last.ps.w:.z.w;.last.ps.a:.z.a;.last.ps.x:x;.last.ps.y:y;.last.ps.r:r];r}.z.ps
/.z.pi:{r:x y;if[.usage.LEVEL>1;.last.pi.when:.z.p;.last.zcmd:`pi;.last.pi.u:.z.u;.last.pi.w:.z.w;.last.pi.a:.z.a;.last.pi.x:x;.last.pi.y:y;.last.pi.r:r];r}.z.pi
.z.ph:{r:x y;if[.usage.LEVEL>1;.last.ph.when:.z.p;.last.zcmd:`ph;.last.ph.u:.z.u;.last.ph.w:.z.w;.last.ph.a:.z.a;.last.ph.x:x;.last.ph.y:y;.last.ph.r:r];r}.z.ph
.z.pp:{r:x y;if[.usage.LEVEL>1;.last.pp.when:.z.p;.last.zcmd:`pp;.last.pp.u:.z.u;.last.pp.w:.z.w;.last.pp.a:.z.a;.last.pp.x:x;.last.pp.y:y;.last.pp.r:r];r}.z.pp
.z.ws:{r:x y;if[.usage.LEVEL>1;.last.ws.when:.z.p;.last.zcmd:`ws;.last.ws.u:.z.u;.last.ws.w:.z.w;.last.ws.a:.z.a;.last.ws.x:x;.last.ws.y:y;.last.ws.r:r];r}.z.ws
