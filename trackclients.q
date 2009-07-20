/ track active clients of a kdb+ session in session table CLIENTS
/ when INSTRUSIVE is true .z.po goes back asking for more background
/ use monitorusage.q or logusage.q if you need request by request info
/ pop - port at po time, _may_ have been changed by a subsequent \p  
\l saveorig.q
@[value;"\\l trackclients.custom.q";::];
if[not`CLIENTS in system"a";
	CLIENTS:([w:`int$()]ipa:`symbol$();u:`symbol$();a:`int$();k:`date$();K:`float$();o:`symbol$();f:`symbol$();pid:`int$();pop:`int$();poz:`datetime$();pcz:`datetime$())]
		
\d .clients
handles:{exec w from value`CLIENTS where not null w}
leaky:{$[INTRUSIVE;`nh xdesc select from(select nh:count i by ipa,pid from value`CLIENTS where not null pop,null pcz) where nh>2;'`no.data]}
po:{[result;arg]
	`CLIENTS upsert(arg;.dotz.ipa .z.a;.z.u;.z.a;0Nd;0n;(`);(`);0N;0N;.z.z;0Nz);
	if[INTRUSIVE;
		(neg arg)"(neg .z.w)\"update k:\",(string .z.k),\",K:\",(string .z.K),\",o:\",(-3!.z.o),\",f:\",(-3!.z.f),\",pid:\",(string .z.i),\",pop:\",(string system\"p\"),\" from`CLIENTS where w=.z.w\""];
	result}   
add:{po[x;x]} / manually add a client 
pc:{[result;arg] update w:0N,pcz:.z.z from`CLIENTS where w=arg;if[AUTOCLEAN;delete from`CLIENTS where null w,pcz<.z.z-.clients.RETAIN];result}
clean:{delete from`CLIENTS where null w,pcz<.z.z-.clients.RETAIN;}

.z.po:{.clients.po[x y;y]}.z.po
.z.pc:{.clients.pc[x y;y]}.z.pc
add each key .z.W;
