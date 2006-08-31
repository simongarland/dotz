/ custom access control, see controlaccess.q for defaults 
/.access.deleteusers .z.u
/.access.FILE:`:invalidaccess.log;
/.access.VALIDHOSTPATTERNS:(string .Q.host .z.a;"127.0.0.1";"localhost");
/.access.VALIDCMDPATTERNS:("select*";"count*");
/.access.STOPWORDS:`delete`exit`access`insert`update`system;
/.access.VALIDCMDSYMBOLS:`symbol$();
.access.VALIDCMDSYMBOLS:`foo`goo;
foo:{2+x};goo:{200+x}
