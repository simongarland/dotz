/ load invalid access via (.z.p*) from logfile into INVALIDACCESS
/ q loadinvalidaccess.q / for default filename or from controlaccess.custom.q
/ q loadinvalidaccess.q FILENAME / to override default 
\l saveorig.q 
@[value;"\\l controlaccess.custom.q";::];

o:.Q.opt .z.x;if[count .Q.x;.access.FILE:hsym`${x[where"\\"=x]:"/";x}first .Q.x]  
INVALIDACCESS:([]pid:`int$();zp:`timestamp$();zcmd:`symbol$();a:`int$();w:`int$();u:`symbol$();cmd:())
LOADINVALIDACCESS:insert
-11!.access.FILE;
ip:{`$"."sv string"i"$0x0 vs x}
INVALIDACCESS:`zp xasc update cmd:`$cmd,date:zp.date,time:zp.time,ipa:.Q.fu[ip']a,host:.Q.fu[.Q.host']a from INVALIDACCESS
INVALIDACCESS:update`s#date from INVALIDACCESS
if[1=count distinct exec date from INVALIDACCESS;INVALIDACCESS:update`s#time from INVALIDACCESS]
INVALIDACCESS:select date,time,pid,zcmd,ipa,host,u,w,cmd from INVALIDACCESS
show(neg first system"c")sublist INVALIDACCESS
