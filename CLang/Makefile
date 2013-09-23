CLang: y.tab.c  y.tab.h lex.yy.c
	gcc -o CLang lex.yy.c y.tab.c

y.tab.c: Cyacc.y
	yacc -d Cyacc.y

y.tab.h: Cyacc.y
	yacc -d Cyacc.y

lex.yy.c: Clex.l
	lex Clex.l

clean: 
	rm -f lex.yy.c y.tab.c y.tab.h
