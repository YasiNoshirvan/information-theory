% Define the probability function
n = 1:10;
pn = zeros(1,10);

for i = 1:length(pn)
    pn(i) = n(i)^-4;
end

% Normalize the probability function
pn_normalized = pn ./ sum(pn);

% Calculate the entropy
entropy = -sum(pn_normalized .* log2(pn_normalized));

disp('Entropy:');
disp(entropy);
