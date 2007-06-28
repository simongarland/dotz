/ dump external (.z.p*) usage of a kdb+ session to console using 0N!
\l saveorig.q

/.z.pw:{0N!x[0N!y;0N!z]}.z.pw
.z.pw:{0N!x[0N!y;z,0#0N!"***"]}.z.pw
.z.po:{0N!x 0N!y}.z.po
.z.pc:{0N!x 0N!y}.z.pc
.z.pg:{0N!x 0N!y}.z.pg
.z.ps:{0N!x 0N!y}.z.ps
.z.pi:{0N!x 0N!y}.z.pi
.z.ph:{0N!x 0N!y}.z.ph
.z.pp:{0N!x 0N!y}.z.pp
