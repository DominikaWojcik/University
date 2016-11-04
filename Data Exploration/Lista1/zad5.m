function zad5()
    d = 100;
    N = 1000;
    M = 1000;
    X = rand(d,N);
    Y = rand(d,M);
    
    najblizszeWektory(X,Y)
    najblizszeWektoryK(X,Y,5)
end

function h = najblizszeWektory(X,Y)
%<u-v,u-v> = <u,u> + <v,v> -2<u,v>
%<u,u> jest stałe
%zatem czynnik wpływajacy na wszystko to <v,v> -2<u,v>
    
    iloczynySkalarne = X' * Y;
    kwadratyDlugosciY = sum(Y.^2);
    odleglosci = bsxfun(@plus, -2 * iloczynySkalarne, kwadratyDlugosciY);
    
    [maxima, h] = min(odleglosci, [], 2);
end

function H = najblizszeWektoryK(X,Y,k)
%<u-v,u-v> = <u,u> + <v,v> -2<u,v>
%<u,u> jest stałe
%zatem czynnik wpływajacy na wszystko to <v,v> -2<u,v>

	iloczynySkalarne = X' * Y;
    kwadratyDlugosciY = sum(Y.^2);
    odleglosci = bsxfun(@plus, -2 * iloczynySkalarne, kwadratyDlugosciY);
    
    [posortowane, indeksy] = sort(odleglosci,2,'ascend');
    H = indeksy(:,1:k)';
end