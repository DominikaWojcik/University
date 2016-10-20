rundy = 10000;
%%%%% BRAMKA 3 TO BRAMKA Z NAGRODA!
%%%%% Strategia zostawania przy swoim
wygraneBezZmiany = 0;
wygraneZeZmiana = 0;
for i = 1:rundy
	bramki = randperm(3);
	numery = 1:3;
	wybor = randi(3);
	puste = find(bramki(numery) < 3 & numery ~= wybor);
	pusta = puste(1);
	%Sprawdzamy goscia, ktory zostaje przy swoim
	if bramki(wybor) == 3
		wygraneBezZmiany = wygraneBezZmiany + 1;
	end

	%Zmieniamy wybor i sprawdzamy
	wybor = find(numery ~= wybor & numery ~= pusta);
	if bramki(wybor) == 3
		wygraneZeZmiana = wygraneZeZmiana + 1;
	end
end

fprintf('Bez zmiany: %f\n', wygraneBezZmiany/rundy);
fprintf('Ze zmiana: %f\n', wygraneZeZmiana/rundy);
