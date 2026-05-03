%% computing KL divergence

obs_data = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10];
obs_num = [1, 3, 2, 8, 22, 45, 44, 42, 24, 8, 3];

total_num = sum(obs_num);

obs_prob = obs_num / total_num;

uniform_prob = (1/11) * ones(1, 11);

KL_divergence = sum(obs_prob .* (log2(obs_prob ./ uniform_prob) .* (obs_prob > 0)));
disp(KL_divergence);

