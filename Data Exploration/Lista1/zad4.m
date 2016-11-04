function zad4()
	d = 100;
	N = 1000;
	M = 1000;
	X = rand(d,N);
	Y = rand(d,M);

    tic;
	policzOdleglosciLepiej(X,Y);
	czas = toc;
	fprintf('Czas policz lepiej dla d=%d, N=%d, M=%d to: %f\n', d, N, M, czas);

	N = 10000;
	X = rand(d,N);

    tic;
	policzOdleglosciLepiej(X,Y);
	czas = toc;
	fprintf('Czas policz lepiej dla d=%d, N=%d, M=%d to: %f\n', d, N, M, czas);
end

function D = policzOdleglosciLepiej(X, Y)
	[D,N] = size(X);
	M = size(Y,2);
	
    iloczynySkalarnePar = X' * Y;
    kwadratyDlugX = sum(X.^2);
    kwadratyDlugY = sum(Y.^2);
    
    %Trzeba rozszerzyć kwadraty dlugosci X i Y do rozmiarów NxM
    %<u-v,u-v> = <u,u> + <v,v> -2<u,v>
    %Kwadraty odleglosci = kwadrtatyDlugosciXrozsz + kwadratyDlugosciYrozsz
    %-2iloczynyskalarnePar
    
    D = -2*iloczynySkalarnePar;
    D = bsxfun(@plus, D, kwadratyDlugX');
    D = bsxfun(@plus, D, kwadratyDlugY);
	D = sqrt(D);
end
