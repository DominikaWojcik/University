hetman(N,X):-
	listaEnum(1,N,L),
	permH(L,X).

listaEnum(N,N,[N]):-!.
listaEnum(L,N,[L|T]):-
	L1 is L+1,
	listaEnum(L1,N,T).

permH([],[]).
permH(L,[H|T]):-
	select(H,L,L1),
	permH(L1,T),
	sprawdz(H,T,1).

sprawdz(_,[],_).
sprawdz(X,[H|T],Odl):-
	not(Odl is abs(X-H)),
	Odl1 is Odl + 1,
	sprawdz(X,T,Odl1).
