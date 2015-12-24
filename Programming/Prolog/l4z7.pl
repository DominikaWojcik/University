%revall(X,Out):-
%	revall(X,[],Out).
%revall([],A,A).
%revall([H|T],A,Out):-
	%write(H),nl,	%Sprawdzamy, czy h jest lista
	%write('Unifikuje sie z lista'),nl,

	%revall(H,[],F),
	%write(F),nl,
	%revall(T,[F|A],Out).

%revall([H|T],A,Out):-
	 %H nie jest lista
	%revall(T,[H|A],Out).

revall(X,Out):-
	revall(X,[],Out).
revall([],A,A).
revall([H|T],A,Out):-
	H = .(_,_),!,
	revall(H,[],F),
	revall(T,[F|A],Out).
revall([H|T],A,Out):-
	revall(T,[H|A],Out).

myReverse([], []) :- !.
myReverse([H|T], X) :-
!,
myReverse(H, NewH),
myReverse(T, NewT),
append(NewT, [NewH], X).
myReverse(X, X).
