putS(E,S,[E|S]).
getS([H|T],H,T).
emptyS([]).
wladujS([H],T,[H|T]).
wladujS([H|T],S,R):-
	wladuj(T,[H|S],R).
addallS(E,G,S,R):-
	findall(E,G,R,S).

lubi(kot,dorsz).
lubi(kot,losos).


putQ(E,S-[E|Ogon],S-Ogon).
getQ([H|T]-Ogon, H, T-Ogon).
emptyQ(L-L).
addallQ(E,G,S-O,S-O2):-
	findall(E,G,O,O2).
	%wladujQ(L,S,R).

wladujQ([H],S,R):-
	putQ(H,S,R).
wladujQ([H|T],S,R):-
	putQ(H,S,S1),
	wladujQ(T,S1,R).

%DFS(V1,V2,Visited,Stack):-
%	getS(Stack,U,S),
%	( \+ member(U,Visited) ->
%	addallS(V,e(U,V),S,S1),DFS(V1,V2,[U|Visited],S1);
%	DFS(V1,V2,Visited,S)).


