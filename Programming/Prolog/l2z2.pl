append([],X,X).
append([H|T],Y,[H|S]):-
	append(T,Y,S).

select(H,[H|T],T).
select(X,[H|T],[H|S]):-
	select(X,T,S).

sublist(_,[]).
sublist([H|T],[H|S]):-
	sublist(T,S).
sublist([_,T],S):-
	sublist(T,S).

