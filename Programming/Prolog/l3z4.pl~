select_min([H],H,[]).
select_min([H|T],H,T):-
	select_min(T,Min,X),
	H =< Min,!.
select_min([H|T],Min,[H|X]):-
	select_min(T,Min,X),
	H > Min.

sel_sort([],[]).
sel_sort(L,[H|T]):-
	select_min(L,H,X),
	sel_sort(X,T).
