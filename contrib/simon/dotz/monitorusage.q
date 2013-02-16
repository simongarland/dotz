/ monitor external (.z.p*) usage of a kdb+ session to session table USAGE
\l dotz.q
if[not`USAGE in system"a";
    USAGE:([]date:`date$();time:`time$();ms:`float$();zcmd:`symbol$();ipa:`symbol$();u:`symbol$();w:`int$();cmd:();ok:`boolean$();sz:`long$();error:`symbol$());
    USAGE:update `s#date from USAGE]

busy:{update busypct:0^100*busyms%totalms from select busyms:sum ms,totalms:last ms+max time-min time by date,time.hh,u from USAGE where ok}
\d .usage
monitor:{[zcmd;endp;result;arg;startp] / record
    if[LEVEL>1;`USAGE insert (`date$startp;`time$startp;0.000001*endp-startp;zcmd;.dotz.ipa .z.a;.z.u;.z.w;.dotz.txtC[zcmd;arg];1b;-22!result;`)];
    result}
monitore:{[zcmd;endp;arg;error] / record error
    if[LEVEL>0;`USAGE insert (`date$endp;`time$endp;0f;zcmd;.dotz.ipa .z.a;.z.u;.z.w;.dotz.txtC[zcmd;arg];0b;0Nj;`$error)];
    'error}

.z.pw:  {.usage.monitor[`pw  ;.z.p;x[y;z]                              ;(y;"***");.z.p]}.z.pw
.z.po:  {.usage.monitor[`po  ;.z.p;x y                                 ;y        ;.z.p]}.z.po
.z.pc:  {.usage.monitor[`pc  ;.z.p;x y                                 ;y        ;.z.p]}.z.pc
.z.pg:  {.usage.monitor[`pg  ;.z.p;@[x;y ;.usage.monitore[`pg;.z.p;y;]];y        ;.z.p]}.z.pg
.z.ps:  {.usage.monitor[`ps  ;.z.p;@[x;y ;.usage.monitore[`ps;.z.p;y;]];y        ;.z.p]}.z.ps
.z.pi:  {.usage.monitor[`pi  ;.z.p;@[x;y ;.usage.monitore[`pi;.z.p;y;]];y        ;.z.p]}.z.pi
.z.ph:  {.usage.monitor[`ph  ;.z.p;@[x;y ;.usage.monitore[`ph;.z.p;y;]];y        ;.z.p]}.z.ph
.z.pp:  {.usage.monitor[`pp  ;.z.p;@[x;y ;.usage.monitore[`pp;.z.p;y;]];y        ;.z.p]}.z.pp
.z.ws:  {.usage.monitor[`ws  ;.z.p;@[x;y ;.usage.monitore[`ws;.z.p;y;]];y        ;.z.p]}.z.ws
.z.exit:{.usage.monitor[`exit;.z.p;x y                                 ;y        ;.z.p]}.z.exit
