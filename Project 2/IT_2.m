% Initialize the transition probability matrix
P = zeros(125,125);

%% normalizing and calculating the Probability matrix
iter = 1;
for xn_3 = 1:5
    for xn_2 = 1:5
        for xn_1 = 1:5
            row_sum = 0;
            for xn = 1:5
                row_sum = row_sum + (max([xn_3, xn_2, xn_1]))^(xn/5);
            end
            for xn = 1:5
                P(state_to_num(xn_3, xn_2, xn_1), state_to_num(xn_2, xn_1, xn)) = (max([xn_3, xn_2, xn_1]))^(xn/5) / row_sum;
            end
        end
    end
end

%% Calculate asymptotic state distribution

% First we Calculate left eigenvectors and eigenvalues
[eigenvectors, eigenvalues] = eig(P.');

% then we find the index of the eigenvalue 1
epsilon = 0.0001;
eigenvalue1_index = find(abs(diag(eigenvalues) - 1) < epsilon);

% then we find the corresponding eigenvector to eigenvalue 1
p_infinity = eigenvectors(:, eigenvalue1_index)';

% finally we normalize the p_inf, so that the sum of all values=1
p_infinity = p_infinity / sum(p_infinity);

disp('Asymptotic state distribution =');
disp(p_infinity);

%% calculating entropy rate
H_bar = 0;
for i = 1:length(p_infinity)
    sum_conditional_dists = 0;
    [x3, x2, x1] = num_to_state(i);
    for j = 1:5
        number_of_state = state_to_num(x2, x1, j);
        conditional_dist = P(i, number_of_state) * log2(P(i, number_of_state));
        sum_conditional_dists = sum_conditional_dists + conditional_dist;
    end
    H_bar = H_bar - p_infinity(i)*sum_conditional_dists;
end

disp("Entropy Rate: H_bar = ")
disp(H_bar);

%% functions
% this function gets a state number and convert it to the corresponding
% state
function [x3, x2, x1] = num_to_state(num)
    x3 = floor((num-1)/25) + 1;
    num = num - (x3-1)*25;
    x2 = floor((num-1)/5) + 1;
    num = num - (x2-1)*5;
    x1 = num;
end

% this function gets a state and convert it to the corresponding state
% number
function num = state_to_num(x3, x2, x1)
    num = 0;
    num = num + (x3-1)*25;
    num = num + (x2-1)*5;
    num = num + x1;
end