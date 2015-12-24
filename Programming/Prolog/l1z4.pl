male(adam).
male(john).
male(mark).
male(joshua).
male(david).
female(eve).
female(helen).
female(ivonne).
female(anna).
parent(adam,helen).
parent(adam,ivonne).
parent(adam,anna).
parent(eve,helen).
parent(eve,ivonne).
parent(eve,anna).
parent(john,joshua).
parent(helen,joshua).
parent(ivonne,david).
parent(mark,david).


sibling(A,B):-
	parent(C,A),
	parent(C,B),
	A\=B.

sister(A,B):-
	female(A),
	sibling(A,B).

grandson(A,B):-
	parent(C,A),
	parent(B,C),
	male(A).

cousin(A,B):-
	parent(C,A),
	parent(D,B),
	sibling(C,D),
	A\=B.

descendant(A,B):-
	parent(B,A).

descendant(A,B):-
	parent(B,C),
	descendant(A,C).


is_father(A):-
	parent(A,B),
	male(A).

is_mother(A):-
	parent(A,B),
	female(A).

















