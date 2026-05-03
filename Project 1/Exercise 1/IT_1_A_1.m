% Entropy of a binary random variable
fplot(@(p) p*log2(1/p)+(1-p)*log2(1/(1-p)),[0 1]);
