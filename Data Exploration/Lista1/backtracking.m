function [Sol, success] = backtracking(Grid)
    %Jesli nie ma zer to wygralem
    if isempty(find(Grid == 0,1))
        Sol = Grid;
        success = true;
        return;
    end

    Sol = Grid;
    success = false;
    indices = 1:(9*9);
    
    %Probuje wstawiac tam gdzie moge
    OnlyOnes = findOnlyOnes(Grid);
    while ~isempty(OnlyOnes)
        for x = OnlyOnes
            possibility = possibilities(Grid, x);
            %Byc moze to pole juz nie ma jednego, tylko zero kandydatow
            if(isempty(possibility))
                return;
            end
            Grid(x) = possibility;
        end
        OnlyOnes = findOnlyOnes(Grid);
    end
    
    %Byc moze nie ma juz co wstawiac
    if isempty(find(Grid == 0,1))
        Sol = Grid;
        success = true;
        return;
    end
 
    %Patrze czy nie ma pola ktore jest w efekcie zablokowane
    if blocked(Grid)
        return;
    end

    %Probujemy kazda mozliwosc  
    for x = indices
        possible = possibilities(Grid, x);
        if length(possible) < 2
            continue;
        end
        for picked = possible
            Grid(x) = picked;
            [Sol, success] = backtracking(Grid);
            if success
                return;
            end
            Grid(x) = 0;
        end
    end
end

function R = findOnlyOnes(Grid)
    R = [];
    for i = 1:81
        if(length(possibilities(Grid,i)) == 1)
            R = [R i];
        end
    end
end

function R = blocked(Grid)
    R = false;
    for i = 1:81
        if(Grid(i) == 0 && isempty(possibilities(Grid,i)))
            R = true;
            return;
        end
    end
end


function C = possibilities(Grid, x)
    if Grid(x) ~= 0
        C = [];
        return;
    end

    C = 1:9;
    row = mod((x-1), 9) + 1;
    col = fix((x-1)/9) + 1;
    square_x = row - mod((row-1),3);
    square_y = col - mod((col-1),3);

    taken = union(Grid(row,:), Grid(:,col)');
    taken = union(taken, Grid(square_x:square_x+2,square_y:square_y+2));
    C = setdiff(C, taken);
end