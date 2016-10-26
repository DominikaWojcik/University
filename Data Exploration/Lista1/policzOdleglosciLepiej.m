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
    
    kwadratyDlugXrozsz = kwadratyDlugX' * ones(1,M);
    kwadratyDlugYrozsz = ones(N,1) * kwadratyDlugY;
    D = kwadratyDlugXrozsz + kwadratyDlugYrozsz -2*iloczynySkalarnePar;
	
	D = sqrt(D);
end
