/ control external (.z.p*) access to  a kdb+ session, log access errors to file
/ use <loadinvalidaccess.q> to load and display table INVALIDACCESS
/ control access (in customaccess.q) by:
/ setting .access.HOSTPATTERNS - list of allowed hoststring patterns (";"vs ...) 
/ setting .access.USERTOKENS/POWERUSERTOKENS - list of allowed k tokens (use -5!)
/ adding rows to .access.USERS for .z.u matches 
/ modify the default values using file controlaccess.custom.q (loaded at end if found)
/ ordinary user would normally only be able to run canned queries
/ poweruser can run canned queries and some sql commands 
/ superuser can do anything
\l saveorig.q

\d .access
USERS:([u:`symbol$()]poweruser:`boolean$();superuser:`boolean$())
HOSTPATTERNS:distinct(string .z.h;string .Q.host .z.a;"127.0.0.1";"localhost")except enlist""
USERTOKENS:(+;*;%;-),`mytokens`foo`goo`hoo
POWERUSERTOKENS:USERTOKENS,(?;+;-;%;*;=;<;>;in;within;~:;max;min;*:;last;';#:;avg;wavg) 
MAXSIZE:123456789j / 123MB max - and anyway there's a hard limit of 2G (2.X)

likeany:{0b{$[x;x;y like z]}[;x;]/y}

loginvalid:{[ok;zcmd;cmd] if[not ok;H enlist(`LOADINVALIDACCESS;`INVALIDACCESS;(.z.i;.z.z;zcmd;.z.a;.z.w;.z.u;.dotz.txtC[zcmd;cmd]))];ok}
validuser:{[zu;pu;su]$[su;exec any(`,zu)in u from USERS where superuser;$[pu;exec any(`,zu)in u from USERS where poweruser or superuser;exec any(`,zu)in u from USERS]]}
superuser:validuser[;0b;1b];poweruser:validuser[;1b;0b];defaultuser:validuser[;0b;0b]
validhost:{[za] $[likeany[.dotz.ipa za;HOSTPATTERNS];1b;likeany["."sv string"i"$0x0 vs za;HOSTPATTERNS]]}
validsize:{$[loginvalid[ok:MAXSIZE>-22!x;y;z];x;'`toobig]}

cmdpt:{$[10h=type x;-5!x;x]}
cmdtokens:{raze(raze each)over{$[0h=type x;$[(not 0h=type fx)&1=count fx:first x;fx;()],.z.s each x where 0h=type each x;()]}x}
usertokens:{$[superuser x;0#`;$[poweruser x;POWERUSERTOKENS;$[defaultuser x;USERTOKENS;'`access]]]}
validpt:{all(cmdtokens x)in y}
validcmd:{[u;cmd] $[superuser u;1b;validpt[cmdpt cmd;usertokens u]]}

invalidpt:{'"invalid parse token(s):",raze" ",'string distinct(cmdtokens cmdpt x)except usertokens .z.u}

vpw:{[x;y]loginvalid[;`pw;x]$[defaultuser x;validhost .z.a;0b]}
vpg:{loginvalid[;`pg;x]validcmd[.z.u;x]}
vps:{loginvalid[;`ps;x]$[poweruser .z.u;validcmd[.z.u;x];0b]}
vpi:{loginvalid[;`pi;x]$[0=.z.w;1b;superuser .z.u]}
vph:{loginvalid[;`ph;x]superuser .z.u}
vpp:{loginvalid[;`pp;x]superuser .z.u}

adduser:{[u;pu;su]USERS,:(u;pu;su);}
addsuperuser:adduser[;0b;1b];addpoweruser:adduser[;1b;0b];adddefaultuser:adduser[;0b;0b]
deleteusers:{delete from`.access.USERS where u in x;}

addsuperuser .z.u / task owner is superuser
adddefaultuser ` / allow anonymous users with default access
/adddefaultuser `qcon / allow qcon users with default access
\d .
@[value;"\\l controlaccess.custom.q";::];
mytokens:{asc distinct .access.usertokens .z.u}

/ if logfile doesn't exist create and initialise it
if[()~key .access.FILE;.[.access.FILE;();:;()]]
.access.H:hopen .access.FILE
.z.pw:{$[.access.vpw[y;z];x[y;z];0b]}.z.pw 
/ .z.po - untouched, .z.pw does the checking 
/ .z.pc - untouched, close is always allowed
/.z.pg:{$[.access.vpg[y];x y;.access.invalidpt y]}.z.pg
.z.pg:{$[.access.vpg[y];.access.validsize[;`pg.size;y]x y;.access.invalidpt y]}.z.pg
.z.ps:{$[.access.vps[y];x y;'`access]}.z.ps
.z.pi:{$[.access.vpi[y];x y;.access.invalidpt y]}.z.pi
.z.ph:{$[.access.vph[y];x y;.h.hn["403 Forbidden";`txt;"Forbidden"]]}.z.ph
.z.pp:{$[.access.vpp[y];x y;.h.hn["403 Forbidden";`txt;"Forbidden"]]}.z.pp

\
note that you can put global restrictions on the amount of memory used, and
the maximum time a single interaction can take by setting command line parameters:
-T NNN (where NNN seconds is the maximum duration) - q will signal 'stop
-w NNN (where NNN MB is the maximum memory) - q will *EXIT* with wsfull
could use .z.po+.z.pc to track clients (.z.a+u+w, .z.z + active) - simplest is to use trackclients.q directly 
