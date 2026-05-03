%%comparing the observed data probability and uniform probability

obs_data = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10];
obs_num = [1, 3, 2, 8, 22, 45, 44, 42, 24, 8, 3];

total_num = sum(obs_num);

obs_prob = obs_num / total_num;
set1 = unique(obs_prob);

uniform_prob = (1/11) * ones(1, 11);
set2 = unique(uniform_prob);

difference_set = setdiff(set1, set2);

display(obs_prob);
display(uniform_prob);
display(difference_set);
