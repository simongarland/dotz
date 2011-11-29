/addsuperuser .z.u / task owner is superuser
/adddefaultuser ` / allow anonymous users with default access
/adddefaultuser `qcon / allow qcon users with default access
/HOSTPATTERNS:distinct(string .z.h;string .Q.host .z.a;"127.0.0.1";"localhost")except enlist""
/USERTOKENS:asc distinct(+;*;%;-),`mytokens`foo`goo`hoo
/POWERUSERTOKENS:asc distinct USERTOKENS,(?;+;-;%;*;=;<;>;in;within;~:;max;min;*:;last;';#:;avg;wavg) 
/MAXSIZE:123456789j / 123MB max - and anyway there's a hard limit of 2G (2.X)
