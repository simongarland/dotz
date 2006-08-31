/ load invalid access via (.z.p*) from logfile into INVALIDACCESS
\l saveorig.q 
t:@[value;"\\l customaccess.custom.q";::]
o:.Q.opt .z.x;if[count .Q.x;.access.FILE:hsym`${x[where"\\"=x]:"/";x}first .Q.x]  
INVALIDACCESS:([]z:`datetime$();zcmd:`symbol$();a:`int$();w:`int$();u:`symbol$();cmd:())
LOADINVALIDACCESS:insert
tmp:-11!.access.FILE
ip:{`$"."sv string"i"$0x0 vs x}
INVALIDACCESS:`z xasc update cmd:`$cmd,date:z.date,time:z.time,ipa:.Q.fu[ip']a from INVALIDACCESS
INVALIDACCESS:update `s#date from INVALIDACCESS
if[1=count distinct exec date from INVALIDACCESS;INVALIDACCESS:update `s#time from INVALIDACCESS]
INVALIDACCESS:select date,time,zcmd,ipa,u,w,cmd from INVALIDACCESS
show(neg first system"c")sublist INVALIDACCESS
