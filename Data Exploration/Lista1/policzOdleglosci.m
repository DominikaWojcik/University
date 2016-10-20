function D = policzOdleglosci(X, Y)
	[D,N] = size(X);
	M = size(Y,2);
	D = zeros(N,M);

	for i = 1:N
		rep = X(:,i) * ones(1,M);
		rep = rep - Y;
		for j = 1:M
			difference = rep(:,j);
			D(i,j) = difference' * difference;
		end
	end
	D = sqrt(D);
end
