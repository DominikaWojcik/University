insert([],Elem,[Elem]).
insert([H|T],Elem,[Elem|[H|T]]):-
	Elem =< H,!.
insert([H|T],Elem,[H|Res]):-
	H < Elem,
	insert(T,Elem,Res).

ins_sort([],[]).
ins_sort(L,S):- ins_sort(L,[],S).
ins_sort([],A,A).
ins_sort([H|T],A,S):-
	insert(A,H,Res),
	ins_sort(T,Res,S).reverse(X,Y)
