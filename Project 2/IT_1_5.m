%% For K = 1
% Define the probability function
n = 0:10000;
pn = zeros(1,10001);

for i = 1:length(pn)
    pn(i) = (1+n(i)^2)^-1;
end

% Normalize the probability function
pn_normalized = pn ./ sum(pn);

% Calculate the entropy
entropy = -sum(pn_normalized .* log2(pn_normalized));

disp('Entropy:');
disp(entropy);

%% For K = 2
% Define the probability function
n = 0:50;
pn = zeros(1,51);

for i = 1:length(pn)
    pn(i) = (1+n(i)^2)^-2;
end

% Normalize the probability function
pn_normalized = pn ./ sum(pn);

% Calculate the entropy
entropy = -sum(pn_normalized .* log2(pn_normalized));

disp('Entropy:');
disp(entropy);
