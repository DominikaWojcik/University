function zad4()
	d = 100;
	N = 1000;
	M = 1000;
	X = rand(d,N);
	Y = rand(d,M);

	tic;
	policzOdleglosci(X,Y);
	czas = toc;
	fprintf('Czas dla policz gorzej d=%d, N=%d, M=%d to: %f\n', d, N, M, czas);
    tic;
	policzOdleglosciLepiej(X,Y);
	czas = toc;
	fprintf('Czas policz lepiej dla d=%d, N=%d, M=%d to: %f\n', d, N, M, czas);

	N = 10000;
	X = rand(d,N);

	tic;
	policzOdleglosci(X,Y);
	czas = toc;
	fprintf('Czas dla policz gorzej d=%d, N=%d, M=%d to: %f\n', d, N, M, czas);
    tic;
	policzOdleglosciLepiej(X,Y);
	czas = toc;
	fprintf('Czas policz lepiej dla d=%d, N=%d, M=%d to: %f\n', d, N, M, czas);
end
