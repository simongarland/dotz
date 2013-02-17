/ track active clients of a kdb+ session in session table CLIENTS
/ when INSTRUSIVE is true .z.po goes back asking for more background
/ use monitorusage.q or logusage.q if you need request by request info
/ port - port at po time, _may_ have been changed by a subsequent \p  
/ sz - total (uncompressed) bytes transferred, could use it to bounce greedy clients 
/ startp - when the session started (.z.po)
/ endp - when the session ended (.z.pc)
/ lastp - time of last session activity (.z.pg/ps/ws)
\l dotz.q
@[value;"\\l trackclients.custom.q";::];
if[not`CLIENTS in system"a";
    CLIENTS:([w:`int$()]ipa:`symbol$();u:`symbol$();a:`int$();k:`date$();K:`float$();c:`int$();s:`int$();o:`symbol$();f:`symbol$();pid:`int$();port:`int$();startp:`timestamp$();endp:`timestamp$();lastp:`timestamp$();hits:`int$();sz:`long$())]
LIVECLIENTS::select from CLIENTS where .dotz.liveh w
CLIENTHANDLES::exec w from LIVECLIENTS
ACTIVECLIENTS::select from LIVECLIENTS where hits>0
CLIENTSUMMARY::select w,ipa,u,f,st:startp.second,et:endp.second,lt:lastp.second,hits,sz from CLIENTS

\d .clients
unregistered:{except[key .z.W;exec w from`CLIENTS]}
cleanup:{ / cleanup closed or idle entries 
    if[count w0:exec w from`CLIENTS where not .dotz.livehn w;
        update endp:.z.p,w:0Ni from`CLIENTS where w in w0];
    if[.clients.MAXIDLE>0;
        hclose each exec w from`CLIENTS where .dotz.liveh w,lastp<.z.p-.clients.MAXIDLE];
    delete from`CLIENTS where not .dotz.liveh w,endp<.z.p-.clients.RETAIN;}
hit:{update lastp:.z.p,hits:hits+1i,sz:sz+-22!x from`CLIENTS where w=.z.w;x}
hite:{update lastp:.z.p,hits:hits+1i from`CLIENTS where w=.z.w;'x}
po:{[result;W] 
    cleanup[];
    `CLIENTS upsert(W;.dotz.ipa .z.a;.z.u;.z.a;0Nd;0n;0Ni;0Ni;(`);(`);0Ni;0Ni;zp;0Np;zp:.z.p;0i;0j);
    if[INTRUSIVE;
        neg[W]"neg[.z.w]\"update k:\",(string .z.k),\",K:\",(-3!.z.K),\",c:\",(-3!.z.c),\",s:\",(-3!system\"s\"),\",o:\",(-3!.z.o),\",f:\",(-3!.z.f),\",pid:\",(-3!.z.i),\",port:\",(-3!system\"p\"),\" from`CLIENTS where w=.z.w\""];
    result} 
addw:{po[x;x]} / manually add a client 
pc:{[result;W] update w:0Ni,endp:.z.p from`CLIENTS where w=W;cleanup[];result}

.z.pg:{.clients.hit[@[x;y;.clients.hite]]}.z.pg
.z.ps:{.clients.hit[@[x;y;.clients.hite]]}.z.ps
.z.ws:{.clients.hit[@[x;y;.clients.hite]]}.z.ws

.z.po:{.clients.po[x y;y]}.z.po
.z.pc:{.clients.pc[x y;y]}.z.pc

/ if no other timer then go fishing for zombie clients every .clients.MAXIDLE 
if[not system"t";
    .z.ts:{.clients.cleanup[]};
    system"t ",string floor 1e-6*.clients.MAXIDLE]
