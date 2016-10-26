function H = najblizszeWektoryK(X,Y,k)
%<u-v,u-v> = <u,u> + <v,v> -2<u,v>
%<u,u> >=0 i stałe, <v,v> tak samo
%zatem czynnik wpływajacy na wszystko to -<u,v>
%najblizsze K wektorów to te o największych iloczynach skalarnych <u,v>
	N = size(X,2);
	M = size(Y,2);
    
    iloczynySkalarne = X' * Y;
    [posortowane, indeksy] = sort(iloczynySkalarne,2,'descend');
    H = indeksy(:,1:k)';
end