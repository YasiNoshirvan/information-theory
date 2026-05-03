%% calculate the distortion for each given N,h and then plotting the 
% results
for N = (1:15)*2 + 1
    c = 0;
    for h = [5/N, 10/N, 20/N]
        
        distortion = calculateDistortion(N,h);
        Rate = log2(N+1);
        figure(1);
        hold on
        if c == 0
            plot(distortion, Rate, '*k');
        elseif c == 1
            plot(distortion, Rate, '*b');
        else
            plot(distortion, Rate, '*r');
        end
        c = c + 1;
    end
    
end
legend({'h=5/N', 'h=10/N', 'h=20/N'})
xlabel('Distortion');
ylabel('Rate');
hold off;


%% calculates the distortion based on the mentioned integral
function distortion = calculateDistortion(N, h)
    % Define the thresholds and quantized values
    thresholds = (2*(1:N) - N - 1) * h;
    thresholds = [-inf thresholds inf];
    quantizedValues = (2*(1:N+1) - N - 2) * h;

    % Calculate the distortion
    distortion = 0;
    
    for i = 1:floor(length(thresholds)/2)
        qi = quantizedValues(i);
        if thresholds(i) == -inf
            ti = thresholds(i);
            ti1 = thresholds(i+1);
            temp = 1/2 * ( ...
                exp(ti1) * (ti1^2 - 2*ti1*(qi+1) + qi*(qi+2) +2)  ...
                );
            distortion = distortion + temp;
        else
            ti = thresholds(i);
            ti1 = thresholds(i+1);
            temp = 1/2 * ( ...
                exp(ti1) * (ti1^2 - 2*ti1*(qi+1) + qi*(qi+2) +2)  ...
                -exp(ti) * (ti^2 - 2*ti*(qi+1) + qi*(qi+2) +2)...
                );
            distortion = distortion + temp;
        end
    end
    distortion = distortion *2;
end