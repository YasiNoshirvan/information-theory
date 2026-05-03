%% Question 1
m=7; % number of cells
Nb=2^m-1; % period
pnSequence = comm.PNSequence('Polynomial',[7 4 0], ...
'SamplesPerFrame',Nb,'InitialConditions',[1 1 1 0 1 1 0]);
x1 = pnSequence()';

N0 = sum(x1==0);
N1 = sum(x1==1);
disp('N0 = ');
disp(N0);
disp('N1 = ');
disp(N1);

%% Question 3

NR0 = zeros(1, m);
NR1 = zeros(1, m);

index = 1;
run0_len = 0;
run1_len = 0;

% we add the 127 bit sequence at the end, to calculate the last run
% correctly
x = [x1 x1];

for i=1:2^m
    if x(index) == 1
        run1_len = run1_len + 1;
        if run0_len ~= 0
            NR0(run0_len) = NR0(run0_len) + 1;
            if index > 2^m-1
                break;
            end
        end
        run0_len = 0;
    else
        run0_len = run0_len + 1;
        if run1_len ~= 0
            NR1(run1_len) = NR1(run1_len) + 1;
            if index > 2^m-1
                break;
            end
        end
        run1_len = 0;
    end
    index = index + 1;
end

N_Total = sum(NR0) + sum(NR1);

Ni = NR0 + NR1;

disp('NR0 = ');
disp(NR0);
disp('NR1 = ');
disp(NR1);

%% Question 6
x1b=2*x1-1;
R=ifft(fft(x1b).*conj(fft(x1b))); 

plot(linspace(-63,63,127), circshift(R, 63));
ylabel('R(\tau)');
xlabel('\tau');
grid on
title('﻿Periodic Autocorrelation Plot');

% 1010100010000001101010010111011000101110