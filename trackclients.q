/ track active clients of a kdb+ session in session table CLIENTS
/ commented versions are more intrusive, they go back asking for more background
/ use monitorusage.q or logusage.q if you need request by request info
/ pop - port at po time, _may_ have been changed by a subsequent \p  
\l saveorig.q
t:@[value;"\\l trackclients.custom.q";::]
if[not`CLIENTS in system"a";
	CLIENTS:$[.clients.INTRUSIVE;
		([w:`int$()]ipa:`symbol$();u:`symbol$();a:`int$();k:`date$();K:`float$();o:`symbol$();f:`symbol$();h:`symbol$();pop:`int$();poz:`datetime$());
		([w:`int$()]ipa:`symbol$();u:`symbol$();a:`int$();poz:`datetime$())]]
\d .clients
handles:{exec w from value`CLIENTS}
leaky:{$[INTRUSIVE;`nh xdesc select from(select nh:count i by h,pop from value`CLIENTS where not null pop) where nh>2;'`no.data]}
po:{[result;arg]
	`CLIENTS insert $[INTRUSIVE;
		(arg;.dotz.ipa .z.a;.z.u;.z.a;@[arg;".z.k";0Nd];@[arg;".z.K";0n];@[arg;".z.o";(`)];@[arg;".z.f";(`)];.Q.host .z.a;@[arg;"\\p";0N];.z.z);
		(arg;.dotz.ipa .z.a;.z.u;.z.a;.z.z)];
	result}   
add:{po[x;x]} / manually add a client 
pc:{[result;arg] delete from`CLIENTS where w=arg; result}

.z.po:{.clients.po[x y;y]}.z.po
.z.pc:{.clients.pc[x y;y]}.z.pc
