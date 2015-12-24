dowolna_lista([]).
dowolna_lista([_|T]):-
	dowolna_lista(T).
wypelnij_liste([]).
wypelnij_liste([0|T]):- wypelnij_liste(T).
wypelnij_liste([1|T]):- wypelnij_liste(T).

bin([0]).
bin([1|T]):-
	dowolna_lista(T),
	wypelnij_liste(T).

wypelnij_odwrotnie([1]):- !.
wypelnij_odwrotnie([H|T]):-
	wypelnij_odwrotnie(T),
	(H = 0 ; H = 1).
rbin([0]).
rbin(X):-
	dowolna_lista(X),
	wypelnij_odwrotnie(X).
