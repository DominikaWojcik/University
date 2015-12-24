direct(wroclaw,warszawa).
direct(wroclaw,krakow).
direct(wroclaw,szczecin).
direct(szczecin,lublin).
direct(szczecin,gniezno).
direct(warszawa,katowice).
direct(gniezno,gliwice).
direct(lublin,gliwice).

connection(A,B):-
	direct(A,B).

connection(A,B):-
	direct(A,C),
	connection(C,B).

?- direct(wroclaw,lublin).
?- direct(wroclaw,X).

jedna_przesiadka(A,B):-
	direct(A,C),
	direct(C,B).
?-jedna_przesiadka(X,gliwice).
max_dwie(A,B):-
	direct(A,B).
max_dwie(A,B):-
	jedna_przesiadka(A,B).
max_dwie(A,B):-
	direct(C,B),
	jedna_przesiadka(A,C).
?- max_dwie(X,gliwice).

