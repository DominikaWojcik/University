factorial(0,1):- !.
factorial(N,M):-
	N1 is N-1,
	factorial(N1,M1),
	M is M1 * N.

concat_number([],A,A).
concat_number([H|T],A,Num):-
	A1 is A * 10 + H,
	concat_number(T,A1,Num).
concat_number(Digits,Num):-
	concat_number(Digits,0,Num).

decimal(0,[0]):- !.
decimal(Num, Digits):-
	decimal(Num,[],Digits).

decimal(0,A,A):- !.
decimal(Num,A,Digits):-
	Num1 is Num // 10,
	Mod is Num mod 10,
	decimal(Num1,[Mod|A],Digits).


