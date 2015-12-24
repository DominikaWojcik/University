filter([],[]).
filter([H|T],[H|S]):-
	H >= 0,!,
	filter(T,S).
filter([H|T],S):-
	H < 0,
	filter(T,S).

count(Elem,[],0):- !.
count(Elem,[H|T],N):-
	H = Elem,!,
	count(Elem,T,N1),
	N is N1 + 1.
count(Elem,[H|T],N):-
	%H \= Elem,
	count(Elem,T,N).

exp(Base,0,1):- !.
exp(Base,Exp,Res):-
	Exp1 is Exp - 1,
	exp(Base,Exp1,Res1),
	Res is Res1 * Base.
