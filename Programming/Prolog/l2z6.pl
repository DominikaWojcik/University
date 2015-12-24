appnd([],X,X).
appnd([H|T],Y,[H|S]):-
	appnd(T,Y,S).

selct(H,[H|T],T).
selct(X,[H|T],[H|S]):-
	selct(X,T,S).


%sublist(_,[]).
%sublist(L1,[H|T]):-
	%selct(H,L1,S),
	%appnd(P,Q,S),
	%appnd(P,H,X),
	%appnd(X,Q,L1),
%	sublist(Q,T).

sublist([],[]).
sublist([H|T],[H|S]):-
	sublist(T,S).
sublist([_|T],S):-
	sublist(T,S).
