fplot(@(p) 1/(1-0)*log2(p^0 + (1-p)^0), [0,1])
hold on
fplot(@(p) 1/(1-0.2)*log2(p^0.2 + (1-p)^0.2), [0,1])
hold on
fplot(@(p) 1/(1-0.5)*log2(p^0.5 + (1-p)^0.5), [0,1])
hold on
fplot(@(p) 1/(1-0.9999)*log2(p^0.9999 + (1-p)^0.9999), [0,1])
hold on
fplot(@(p) 1/(1-1.5)*log2(p^1.5 + (1-p)^1.5), [0,1])
hold on
fplot(@(p) 1/(1-2)*log2(p^2 + (1-p)^2), [0,1])
hold on
fplot(@(p) 1/(1-10)*log2(p^10 + (1-p)^10), [0,1])
hold on
fplot(@(p) 1/(1-1000)*log2(p^1000 + (1-p)^1000), [0,1])
legend({'α=0','α=0.2', 'α=0.5', 'α=0.9999', 'α=1.5', 'α=2', 'α=10', 'α=1000'} ...
    ,'Location','south')
xlabel('P (probability)') 
ylabel('H (entropy)') 
hold off