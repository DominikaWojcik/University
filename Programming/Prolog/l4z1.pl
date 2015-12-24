len(L,N):-
	len(L,0,N).
len([],A,A).
len([_|T],A,N):-
	(\+ var(N) -> A \= N ; true),
	A1 is A+1,
	len(T,A1,N).
