/ track active clients of a kdb+ session in session table CLIENTS
/ when INSTRUSIVE is true .z.po goes back asking for more background
/ use monitorusage.q or logusage.q if you need request by request info
/ port - port at po time, _may_ have been changed by a subsequent \p  
\l dotz.q
@[value;"\\l trackclients.custom.q";::];
if[not`CLIENTS in system"a";
	CLIENTS:([w:`int$()]ipa:`symbol$();u:`symbol$();a:`int$();k:`date$();K:`float$();c:`int$();s:`int$();o:`symbol$();f:`symbol$();pid:`int$();port:`int$();startp:`timestamp$();endp:`timestamp$())]
CLIENTHANDLES::exec w from`CLIENTS where .dotz.liveh w
		
\d .clients
unregistered:{except[key .z.W;exec w from`CLIENTS]}
clean:{if[count w0:exec w from`CLIENTS where not .dotz.livehn w;
        update endp:.z.p,w:0Ni from`CLIENTS where w in w0];
    delete from`CLIENTS where not .dotz.liveh w,endp<.z.p-.clients.RETAIN;}
po:{[result;W] clean[];
    `CLIENTS upsert(W;.dotz.ipa .z.a;.z.u;.z.a;0Nd;0n;0Ni;0Ni;(`);(`);0Ni;0Ni;.z.p;0Np);
	if[INTRUSIVE;
        neg[W]"neg[.z.w]\"update k:\",(string .z.k),\",K:\",(-3!.z.K),\",c:\",(-3!.z.c),\",s:\",(-3!system\"s\"),\",o:\",(-3!.z.o),\",f:\",(-3!.z.f),\",pid:\",(-3!.z.i),\",port:\",(-3!system\"p\"),\" from`CLIENTS where w=.z.w\""];
	result}   
addw:{po[x;x]} / manually add a client 
pc:{[result;W] update w:0Ni,endp:.z.p from`CLIENTS where w=W; clean[]; result}

.z.po:{.clients.po[x y;y]}.z.po
.z.pc:{.clients.pc[x y;y]}.z.pc
