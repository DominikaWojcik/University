function h = najblizszeWektory(X,Y)
	Odl = policzOdleglosci(X,Y);
	N = size(X,2);
	M = size(Y,2);
	h = zeros(1,N);

	for i = 1:N
		currentMin = Inf;
		for j = 1:M
			if currentMin > Odl(i,j)
				currentMin = Odl(i,j);
				h(i) = j;
			end
		end
	end
end