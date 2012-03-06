/ load usage external usage (.z.p*) from logfile FILE into USAGE
/ q loadusage.q / for default filename or from logusage.custom.q
/ q loadusage.q FILENAME / to override default 
\l saveorig.q 
@[value;"\\l logusage.custom.q";::];

o:.Q.opt .z.x;if[count .Q.x;.usage.FILE:hsym`${x[where"\\"=x]:"/";x}first .Q.x]  
USAGE:([id:`long$()]pid:`int$();startz:`datetime$();endz:`datetime$();zcmd:`symbol$();a:`int$();u:`symbol$();w:`int$();cmd:();ok:`boolean$();error:`symbol$();data:())
LD:insert;LB:insert
LA:{x upsert`id`ok`startz`endz!y}
LE:{x upsert`id`ok`endz`error!y}
-11!.usage.FILE;
ip:{`$"."sv string"i"$0x0 vs x}
USAGE:`id`startz xasc update cmd:`$cmd,date:startz.date,time:startz.time,ms:0^86400000*endz-startz,ipa:.Q.fu[ip']a,host:.Q.fu[.Q.host']a from 0!USAGE
USAGE:update `s#date,`g#zcmd from USAGE
if[1=count distinct exec date from USAGE;USAGE:update `s#time from USAGE]
USAGE:select date,time,ms,zcmd,ipa,host,u,pid,w,ok,error,exited:null endz,cmd,data from USAGE
EXITED::select indx:i,date,time,zcmd,ipa,host,u,pid,w,error,cmd from USAGE where exited
EXPENSIVE::`totalms xdesc select totalms,avgms,numcalls,cmd from(0!select totalms:sum ms,avgms:avg ms,numcalls:count i by cmd from USAGE)where totalms>.usage.EXPENSIVE
LOGCONTENTS::exec first each data from USAGE where zcmd in`pg`ps
show(neg first system"c")sublist USAGE

\
to create a -11!able logfile just pick out the data column:
`:mylogfile.log set exec first each data from USAGE where date=.z.d,time within 09:00 10:00,zcmd in`pg`ps,exited
`:mylogfile.log set LOGCONTENTS
