hp:{`$raze":",'string(.z.h;system"p")} / my `:host:port 
xip:{{"I"$(x?"<")#x}{(9+first ss[x;"Address: "])_x}`:http://checkip.dyndns.com:8245"GET HTTP/1.1\r\nHost: checkip.dyndns.com:8245\r\n\r\n"} / external IPaddress
xhp:{`${":",x,":",string system"p"}{(x?"<")#x}{(9+first ss[x;"Address: "])_x}`:http://checkip.dyndns.com:8245"GET HTTP/1.0\r\nHost: checkip.dyndns.com:8245\r\n\r\n"} / external `:host:port

sessioninfo:{.Q.w[],`k`K`o`f`h`pid`port`s`q`ro`g!(.z.k;.z.K;.z.o;.z.f;.z.h;.z.i;system"p";system"s";.z.q;system"_";system"g")}
hostpid:{`host`pid!(.z.h;.z.i)}
sysinfo:{`cores`os`u1`u5`u15!.z.c,.z.o,("F"$(-5#-4!first system"uptime")0 2 4)}

withw:{((enlist`w)!enlist y),y(x;::)}
hhostpid:withw hostpid / hhostpid each key .z.W / use to get distinct tasks 
hsessioninfo:withw sessioninfo
hsysinfo:withw sysinfo / hsysinfo each key .z.W / to see which servers are most loaded

httpget:{[host;location] (`$":http://",host)"GET ",location," HTTP/1.0\r\nHost:",host,"\r\n\r\n"} 
hvalid:{(abs x)in key .z.W}
hclogged:{where 0<count each .z.W}
hkill:{@[{neg[x]"\\\\";1b};x;{not": Bad file descriptor"~21#x}]} / kill the task at the other end of a handle 
hkill2:{@[x;"exit 0";{}]}
htzoffset:{floor 0.5+24*neg .z.z-x".z.Z"} / server timezone offset for handle

/ execute[handles;cmd]
hdsx0:{{x[]}each{neg[x]({neg[.z.w]value x};y);neg[x][];x}[;y]each x,()} / deferred sync execute, no traps
hdsx:{flip`w`ok`result!(enlist x),flip{x[]}each{neg[x]({neg[.z.w]@[{(1b;value x)};x;{(0b;x)}]};y);neg[x][];x}[;y]each x,:()}
hx0:{{x y}[;y]each x} / sync execute, no traps 
hx:{flip`w`ok`result!(enlist x),flip{x({@[{(1b;value x)};x;{(0b;x)}]};y)}[;y]each x,:()}
\
if using trackservers.q then can do things like:
hndsx:{hdsx[.servers.handlefor each x;y]} / hndsx[`rtdb`hdb;"select count i by ex from trade"]
hnx:{hx[.servers.handlefor each x;y]}
