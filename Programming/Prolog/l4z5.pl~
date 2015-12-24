insert(leaf,Elem,node(leaf,Elem,leaf)).
insert(node(L,V,R),Elem,node(T,V,R)):-
	Elem =< V,!,
	insert(L,Elem,T).
insert(node(L,V,R),Elem,node(L,V,T)):-
	%Elem > V,
	insert(R,Elem,T).

treesort(L,S):-
	treesort(L,S,leaf).

treesort([],S,T):-
	flatten(T,S).
treesort([H|T],S,A):-
	insert(A,H,A1),
	treesort(T,S,A1).
