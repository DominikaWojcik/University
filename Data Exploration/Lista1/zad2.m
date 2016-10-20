function GRID = zad2()
    X = kron(eye(3), reshape(randperm(9),3,3));
    GRID = backtracking(X);
end