perm(X,Y):- perm(X,Y,Y).
perm([],[],[]).
perm(L,[H|T],[_|G]):-
	select(H,L,S),
	perm(S,T,G).
sublist(_,[]).
sublist([H|T],[H|S]):-
	sublist(T,S).
sublist([_ |T],S):-
	sublist(T,S).
