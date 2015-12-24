perm(X,Y):-
	perm(X,Y,Y).
perm([],[],[]).
perm([H|T],P,[_|G]):-
	perm(T,R,G),
	select(H,P,R).
