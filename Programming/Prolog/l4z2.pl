connection(wroclaw,warszawa).
connection(wroclaw,krakow).
connection(wroclaw,szczecin).
connection(szczecin,lublin).
connection(szczecin,gniezno).
connection(warszawa,katowice).
connection(gniezno,gliwice).
connection(lublin,gliwice).

trip(X,Y,T):-
	trip(X,Y,T,[]).
trip(X,Y,[X|A],A):-
	connection(X,Y).
trip(X,Y,T,A):-
	connection(Z,Y),
	not(member(Z,A)),
	trip(X,Z,T,[Z|A]).
