grid = zeros(9);
continueLoop = true;

while continueLoop
    continueLoop = false;
    
    for i = 1 : 9
        grid(i, :) = randperm(9);
    end
    
    for i = 1 : 9
        column = grid(:,i)';
        if ~isequal(sort(column),  1:9)
            continueLoop = true;
            break;
        end
    end
    
    if continueLoop 
        continue;
    end
    
    for i = 0 : 2
        for j = 0 : 2
            square = grid(3*i+1 : 3*(i+1), 3*j+1 : 3*(j+1));
            if sort(reshape(square, 1, 9)) ~= 1:9
                continueLoop = true;
                break;
            end
        end
    end
end

disp(grid);
    