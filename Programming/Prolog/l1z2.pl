nie_jest_smokiem(X):-
	mieszka_w_zoo(X),
	szczesliwy(X).

szczesliwy(X):-
	zwierze(X),
	styka_sie(X,Y),
	czlowiek(Y),
	mily(Y).

mily(X):-
	czlowiek(X),
	odwiedza_zoo(X).

styka_sie(X,Y):-
	zwierze(X),
	mieszka_w_zoo(X),
	czlowiek(Y),
	odwiedza_zoo(Y).


%Alternatywny: 1)Ka¿dy smok jest szczesliwy, 2)cokolwiek
%Smok jest zwierzêciem , ktoœ w ogóle odwiedza zoo
