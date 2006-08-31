hhostport:{`$raze":",'string(.z.h;system"p")} / `:host:port 
hwhois:{`k`K`o`f`h`port`w!(@[x;".z.k";0Nd];@[x;".z.K";0n];@[x;".z.o";(`)];@[x;".z.f";(`)];@[x;".z.h";(`)];@[x;"\\p";0N];x:abs x)}
hhere:{`k`K`o`f`h`port`w!(.z.k;.z.K;.z.o;.z.f;.z.h;system"p";0)}
/hvalid:{@[{not 0b~@[neg x;"";0b]};x;0b]}
hvalid:{(::)~@[neg abs x;"";0b]}
/hkill:{@[{x"\\\\"};x;{"rcv: An existing c"~18#x}]}
hkill:{@[{(neg x)"\\\\";1b};x;{not": The handle is in"~18#x}]} / kill the task at the other end of a handle 
htzoffset:{floor 0.5+24*neg .z.z-x".z.Z"} / server timezone offset 
/ execute[handles;cmd]
hdsx0:{{x[]}each{(neg x)({(neg .z.w)value x};y);x}[;y]each x,()} / deferred sync execute, no traps
hdsx:{flip`w`ok`result!(enlist x),flip{x[]}each{(neg x)({(neg .z.w)@[{(1b;value x)};x;{(0b;x)}]};y);x}[;y]each x,:()}
hx0:{{x y}[;y]each x} / sync execute, no traps 
hx:{flip`w`ok`result!(enlist x),flip{x({@[{(1b;value x)};x;{(0b;x)}]};y)}[;y]each x,:()}
\
if using trackservers.q then can do things like:
hndsx:{hdsx[.servers.handlefor each x;y]} / hndsx[`rtdb`hdb;"select count i by ex from trade"]
hnx:{hx[.servers.handlefor each x;y]}
