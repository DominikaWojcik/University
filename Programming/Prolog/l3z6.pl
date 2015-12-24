%dlugosc([],[]).
%dlugosc([_|T],[_|O]):-
%	dlugosc(T,O).

%reverse(X,Y):-
%	dlugosc(X,Y),
%	reverse(X,[],Y).

%reverse([],A,A).
%reverse([H|T],A,Y):-
%	reverse(T,[H|A],Y).
rev(X,Y) :-
rev(X,[],Y, Y).

rev([],A,A,[]).
rev([H|T],A,Y,[_|X]) :-
rev(T,[H|A],Y, X ).
