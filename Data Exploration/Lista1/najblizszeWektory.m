function h = najblizszeWektory(X,Y)
%<u-v,u-v> = <u,u> + <v,v> -2<u,v>
%<u,u> >=0 i stałe, <v,v> tak samo
%zatem czynnik wpływajacy na wszystko to -<u,v>
%najblizszy to ten o najwiekszym iloczynie skalarnym!
	
	N = size(X,2);
	M = size(Y,2);
    
    iloczynySkalarne = X' * Y;
    [maxima, h] = max(iloczynySkalarne, [], 2);
end