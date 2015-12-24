sublist([],[]).
sublist([H|T],[H|S]):-
	sublist(T,S).
sublist([_|T],S):-
	sublist(T,S).

concat_number([],A,A).
concat_number([H|T],A,Num):-
	A1 is A * 10 + H,
	concat_number(T,A1,Num).

concat_number(Digits,Num):-
	concat_number(Digits,0,Num).

dodaj(Skladniki,Wynik):-
	dodaj(Skladniki,0,Wynik).
dodaj([],Wynik,Wynik).
dodaj([H|T],A,Wynik):-
	concat_number(H,Skladnik),
	A1 is A + Skladnik,
	dodaj(T,A1,Wynik).

rozwiaz(Zmienne,Skladniki,Suma):-
	length(Zmienne,N),
	%write(N),nl,
	length(X,N),
	sublist([0,1,2,3,4,5,6,7,8,9],X),
	%write(X),nl,
	permutation(Zmienne,X),
	%write(Zmienne),nl,
	dodaj(Skladniki,Wynik1),
	concat_number(Suma,Wynik2),
	\+ Wynik1 \=  Wynik2.

