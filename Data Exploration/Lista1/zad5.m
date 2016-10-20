function zad5()
    d = 100;
    N = 1000;
    M = 1000;
    X = rand(d,N);
    Y = rand(d,M);
    
    najblizszeWektory(X,Y)
    najblizszeWektoryK(X,Y,5)
end