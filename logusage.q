/ log external (.z.p* & .z.exit) usage of a kdb+ session to .usage.FILE
/ use <loadusage.q> to load and create table USAGE
\l dotz.q
@[value;"\\l logusage.custom.q";::];

\d .usage
logDirect:{[id;zcmd;endp;result;arg;startp] / log complete action
    if[LEVEL>1;H enlist(`LD;`USAGE;(id;.z.i;startp;endp;zcmd;.z.a;.z.u;.z.w;.dotz.txtC[zcmd;arg];1b;0Nj;`;enlist arg))];result}
logBefore:{[id;zcmd;arg;startp] / log non-time info before execution
    if[LEVEL>1;H enlist(`LB;`USAGE;(id;.z.i;startp;0Np;zcmd;.z.a;.z.u;.z.w;.dotz.txtC[zcmd;arg];0b;0Nj;`;enlist arg))];}
logAfter:{[id;endp;result;startp] / fill in time info after execution
    if[LEVEL>1;H enlist(`LA;`USAGE;(id;1b;startp;endp;-22!result))];result}
logError:{[id;endp;error] / fill in error info
    if[LEVEL>0;H enlist(`LE;`USAGE;(id;0b;endp;`$error))];'error}
/ if logfile doesn't exist create and initialise it
if[()~key FILE;.[FILE;();:;()]]
H:hopen FILE;HJ:hcount FILE
nextid:{:HJ+:1}

p0:{[x;y;z;a]logDirect[nextid[];`pw;.z.p;y[z;a];(z;"***");.z.p]}
p1:{logDirect[nextid[];x;.z.p;y z;z;.z.p]}
p2:{id:nextid[];logBefore[id;x;z;.z.p];logAfter[id;.z.p;@[y;z;logError[id;.z.p;]];.z.p]}

.z.pw:p0[`pw;.z.pw;;]
.z.po:p1[`po;.z.po;];.z.pc:p1[`pc;.z.pc;]
.z.ws:p2[`ws;.z.ws;];.z.exit:p2[`exit;.z.exit;];
.z.pg:p2[`pg;.z.pg;];.z.ps:p2[`ps;.z.ps;];.z.pi:p2[`pi;.z.pi;];
.z.ph:p2[`ph;.z.ph;];.z.pp:p2[`pp;.z.pp;]

