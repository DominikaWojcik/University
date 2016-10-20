function H = najblizszeWektoryK(X,Y,k)
	Odl = policzOdleglosci(X,Y);
	N = size(X,2);
	M = size(Y,2);
	H = zeros(k,N);

	for i = 1:N
		%Posortowane pary (odległosc, id)
		tmp = sortrows([Odl(i,:)' [1:M]']);
		H(:,i) = tmp(1:k,2);
	end
end