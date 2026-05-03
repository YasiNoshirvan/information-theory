%% computing KL divergence

obs_data = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10];
obs_num = [1, 3, 2, 8, 22, 45, 44, 42, 24, 8, 3];
total_num = sum(obs_num);
obs_prob = obs_num / total_num;
uniform_prob = (1/11) * ones(1, 11);

KL_divergence = sum(obs_prob .* (log2(obs_prob ./ uniform_prob) .* (obs_prob > 0)));


%% Identify the pmf at minimum KL divergence

min_KL_divergence = inf;
best_p = 0;
best_binomial_pmf = [];

p_values = 0.001:0.001:0.999;

KL_divergences = zeros(1, length(p_values));
binomial_pmfs = cell(1, length(p_values));

for i = 1:length(p_values)
    p = p_values(i);
    binomial_pmf = zeros(1, 11);
    
    for x = 0:10
        binomial_pmf(x+1) = nchoosek(10, x) * (p ^ x) * ((1 - p) ^ (10 - x));
    end
    
    binomial_pmfs{i} = binomial_pmf;
    
    KL_divergence = sum(obs_prob .* (log2(obs_prob ./ binomial_pmf) .* (obs_prob > 0)));
    kl_distances(i) = KL_divergence;
    
    if KL_divergence < min_KL_divergence
        min_KL_divergence = KL_divergence;
        best_p = p;
        best_binomial_pmf = binomial_pmf;
    end
end

[~, min_kl_index] = min(KL_divergence);
best_binomial_pmf = binomial_pmfs{min_kl_index};

disp(['Best p: ', num2str(best_p)]);
disp(['Min Kullback-Leibler Divergence: ', num2str(min_KL_divergence)]);

