%% calculate the distortion for each given N,h and then plotting the 
% results
for N = (1:15)*2 + 1
    c = 0;
    for h = [1/N, 3/N, 10/N]
        distortion = calculateDistortion(N,h);
        Rate = 2*log2(N+1);
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
legend({'h=1/N', 'h=3/N', 'h=10/N'})
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
    
    for i = 1:length(thresholds)-1
        qi = quantizedValues(i);
        func = @(x) 2 * (x-qi).^2 .* exp(- (x.^2)/2)/(sqrt(2.*pi()));
        distortion = distortion + integral(func, thresholds(i) ...
            , thresholds(i+1));
    end
end