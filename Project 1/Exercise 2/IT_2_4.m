syms beta
mu = 28;
eqn = (beta^20 + beta^50 + beta^30 + beta^15 + beta^25)*mu == (20*beta + 50*beta^2 + 30*beta^3 + 15*beta^4 + 25*beta^5);
V = vpasolve(eqn,beta,[0 10])

beta_ans = V(2)
alpha_ans = 1/(beta_ans^20+beta_ans^50+beta_ans^30+beta_ans^15+beta_ans^25)
costs = [20, 50, 30, 15, 25]
probs = alpha_ans*beta_ans.^costs
sum(probs)

x = ["t-shirt" "jacket" "pants" "gloves" "shoes"];
bar(x, probs)
ylabel('Probability') 