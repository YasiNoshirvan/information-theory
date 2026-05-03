% Define the probability function
n = 0:10;
pn = zeros(1,11);

for i = 1:length(pn)
    pn(i) = exp(-n(i)^2);
end

% Normalize the probability function
pn_normalized = pn ./ sum(pn);

% Calculate the entropy
entropy = -sum(pn_normalized .* log2(pn_normalized));

disp('Entropy:');
disp(entropy);
