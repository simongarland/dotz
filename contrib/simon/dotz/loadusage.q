/ load usage external usage (.z.p*) from logfile FILE into USAGE
/ q loadusage.q / for default filename or from logusage.custom.q
/ q loadusage.q FILENAME / to override default 
\l saveorig.q 
t:@[value;"\\l logusage.custom.q";::]

o:.Q.opt .z.x;if[count .Q.x;.usage.FILE:hsym`${x[where"\\"=x]:"/";x}first .Q.x]  
USAGE:([]startz:`datetime$();endz:`datetime$();zcmd:`symbol$();a:`int$();u:`symbol$();w:`int$();cmd:();ok:`boolean$();error:`symbol$())
LOADUSAGE:insert
tmp:-11!.usage.FILE
ip:{`$"."sv string"i"$0x0 vs x}
USAGE:`startz xasc update cmd:`$cmd,date:startz.date,time:startz.time,ms:86400000*endz-startz,ipa:.Q.fu[ip']a,host:.Q.fu[.Q.host']a from USAGE
USAGE:update `s#date from USAGE
if[1=count distinct exec date from USAGE;USAGE:update `s#time from USAGE]
USAGE:select date,time,ms,zcmd,ipa,host,u,w,cmd,ok,error from USAGE
busy:{update busypct:0^100*busyms%totalms from select busyms:sum ms,totalms:last ms+max time-min time by date,time.hh,u from USAGE where ok}
show(neg first system"c")sublist USAGE
