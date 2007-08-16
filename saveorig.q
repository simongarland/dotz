/ save the original values in .z.p* so we can <revert> 
\d .dotz
if[not@[value;`SAVED.ORIG;0b]; / onetime save only
	SAVED.ORIG:1b;
	IPA:(enlist .z.a)!enlist .z.h;
	ipa:{$[`~r:IPA x;IPA[x]:$[`~r:.Q.host x;`$"."sv string"i"$0x0 vs x;r];r]}; 
	.usage.LEVEL:@[.:;`.usage.LEVEL;2]; / 0 - nothing; 1 - errors only; 2 - all
	.access.FILE:@[.:;`.access.FILE;`:invalidaccess.log];
	.usage.FILE:@[.:;`.usage.FILE;`:usage.log];
	.usage.EXPENSIVE:@[.:;`.usage.EXPENSIVE;1000]; / expensive executon is coloured in traceusage.q
	.clients.INTRUSIVE:@[.:;`.clients.INTRUSIVE;0b];
	.clients.RETAIN:@[.:;`.clients.RETAIN;5%24*60]; / 5 minutes
	.clients.AUTOCLEAN:@[.:;`.clients.AUTOCLEAN;1b]; / clean out old records when handling a close 
	.servers.HOPENTIMEOUT:@[.:;`.servers.HOPENTIMEOUT;500]; / half a second timeout  
	.servers.RETRY:@[.:;`.servers.RETRY;prd 5 60 1000]; / 5 minutes  
	.tasks.RETAIN:@[.:;`.tasks.RETAIN;5%24*60]; / 5 minutes
	.tasks.AUTOCLEAN:@[.:;`.tasks.AUTOCLEAN;1b]; / clean out old records when handling a close 
	@[value;"\\l saveorig.custom.q";::];
	fsw:{first system"w"};
	txt:{[width;zcmd;arg]t:$[10=abs type arg;arg;-3!arg];if[zcmd in`ph`pp;t:.h.uh t];$[width<count t;(15#t),"..",(17-width)#t;t]};
	txtc:txt[neg 60-last system"c"];txtC:txt[neg 60-last system"C"];
	pzlist:` sv'`.z,' `pw`po`pc`pg`ps`pi`ph`pp;
	.dotz.undef:pzlist where not @[{not(::)~value x};;0b] each pzlist;
	.dotz.pw.ORIG:.z.pw:@[.:;`.z.pw;{{[x;y]1b}}];
	.dotz.po.ORIG:.z.po:@[.:;`.z.po;{;}];
	.dotz.pc.ORIG:.z.pc:@[.:;`.z.pc;{;}];
	.dotz.pg.ORIG:.z.pg:@[.:;`.z.pg;{.:}];
	.dotz.ps.ORIG:.z.ps:@[.:;`.z.ps;{.:}];
	.dotz.pi.ORIG:.z.pi:@[.:;`.z.pi;{{.Q.s value x}}];
	.dotz.ph.ORIG:.z.ph; / .z.ph is defined in q.k
	.dotz.pp.ORIG:.z.pp:@[.:;`.z.pp;{;}]; / (poststring;postbody)
	revert:{.z.pw:.dotz.pw.ORIG;.z.po:.dotz.po.ORIG;.z.pc:.dotz.pc.ORIG;.z.pg:.dotz.pg.ORIG;.z.ps:.dotz.ps.ORIG;.z.pi:.dotz.pi.ORIG;.z.ph:.dotz.ph.ORIG;.z.pp:.dotz.pp.ORIG;.dotz.SAVED.ORIG:0b;
		if[.z.K>2.3;{system"x ",string x}each .dotz.undef];}
	]
