NW = 512;
clear mean_value;
clear variance;

data = rand(1, 10000);
mean_value = mean(data);
variance = var(data);

pattern = rand(1, 1000);
correlation_coefficient = 0.8; 
for i = 2:1000
    pattern(i) = correlation_coefficient * pattern(i - 1) + (1 - correlation_coefficient) * pattern(i);
end

pattern = pattern * sqrt(variance * 0.95 / var(pattern));
pattern = pattern - mean(pattern) + mean_value * 0.95;

disp(mean(pattern));
disp(var(pattern));

data(3000:3999) = pattern;

subplot(2,1,1)
plot(data);
title('data series');

permutation_entropy_list = zeros(1, length(data)-NW);
for i = 1:length(data)-(NW-1)
    window = data(i:i+NW-1);
    permutation_entropy_list(i) = permutation_entropy(window);
end
permutation_entropy_list = permutation_entropy_list ./ log2(factorial(3));

subplot(2,1,2)
plot(permutation_entropy_list);
title('permutation entropy Nw=512 L=3');
ylim([0.9 1.1]);

function H = permutation_entropy(sliding_window)
    permutations = [1 2 3; 1 3 2; 2 1 3; 2 3 1; 3 1 2; 3 2 1];
    permutations = transpose(permutations);
    outcomes = [0 0 0 0 0 0];
    
    matrix = [sliding_window(1:length(sliding_window)-2);sliding_window(2:length(sliding_window)-1);sliding_window(3:length(sliding_window))];
    secondMatrix = [];
    
    for i = 1:length(matrix)
        column = matrix(:,i);
        secondMatrix = [secondMatrix;findOrder(column)];
    end
    
    secondMatrix = transpose(secondMatrix);
    
    for i = 1:length(secondMatrix)
        for j = 1:length(permutations)
            if secondMatrix(:,i) == permutations(:,j)
                outcomes(j) = outcomes(j) + 1;
            end
        end
    end
    
    probabilities = outcomes ./ sum(outcomes);
    H = entropy(probabilities);
end


function H = entropy(p)
    H = 0;
    for i = 1:length(p)
        H = H + p(i) * log2(1/p(i));
    end
end

function y = findOrder(arr)
    if arr(1) <= arr(2) && arr(1) <= arr(3)
        if arr(2) <= arr(3)
            y = [1 2 3];
        else
            y = [1 3 2];
        end
    elseif arr(2) <= arr(1) && arr(2) <= arr(3)
        if arr(1) <= arr(3)
            y = [2 1 3];
        else
            y = [3 1 2];
        end
    else
        if arr(1) <= arr(2)
            y = [2 3 1];
        else
            y = [3 2 1];
        end
    end
end