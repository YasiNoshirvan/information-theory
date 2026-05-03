N = 100;
digits(50000);
[X, thresholds] = lloyd(N);
distortion = calculate_distortion(X, thresholds);

%% implementation of lloyd algorithm
function [X, thresholds] = lloyd(N)
    % initialize the thresholds and quantized values as mentioned in
    % the question
    thresholds = -(N-1)/2:1:(N-1)/2;
    thresholds = [-inf thresholds inf];
    X = -N/2:1:N/2;

    disp("Init values :");
    disp("Thresholds = ");
    disp(thresholds);
    disp("X = ")
    disp(X);
    i = 1;
    while true
        distortion = calculate_distortion(X, thresholds);
        % disp(distortion);
        Xprev = X;
        % Calculating new thresholds
        for j = 1:N
            thresholds(j+1) = (X(j) + X(j+1)) / 2;
        end

        % Calculating new X
        for j = 1:N+1
            X(j) = calculate_xi(thresholds(j+1), thresholds(j-1+1));
        end
        % Checking the end statement
        i = i + 1;
        if norm2(X, Xprev) < 0.01
            break;
        end 
    end
    disp("Final quantization values :");
    disp("Thresholds = ");
    disp(thresholds);
    disp("X = ")
    disp(X);
    disp("Average quantization error = ");
    disp(distortion);
end


%% calculating ||x^(n+1)-x^(n)||^2
function output = norm2(x, y)
    output = sum((x-y).^2);
end

%% calculate xi using the closed form of integral
% more details of the closed form is written in the report
function xi = calculate_xi(ti, ti_1)
    if ti > 0 && ti_1 > 0
        if ti == inf
            integral_xfx = (ti_1 + 1)*exp(-ti_1);
            integral_fx = exp(-ti_1);
        else
            integral_xfx = (ti_1 + 1)*exp(-ti_1) - (ti + 1)*exp(-ti);
            integral_fx = exp(-ti_1) - exp(-ti);
        end
    elseif ti > 0 && ti_1 < 0
        integral_xfx = 1 - (ti + 1)*exp(-ti) - exp(ti_1)*(ti_1 - 1) - 1;
        integral_fx = sinh(ti) - cosh(ti) + 1 + 1 - exp(ti_1);
    else
        if ti_1 == -inf
            integral_xfx = (ti - 1)*exp(ti);
            integral_fx = exp(ti);
        else
            integral_xfx = (ti - 1)*exp(ti) - (ti_1 - 1)*exp(ti_1);
            integral_fx = exp(ti) - exp(ti_1);    
        end
    end
    xi = integral_xfx / integral_fx;
end

%% calculating the distortion using the closed form of D
% more details of the closed form is written in the report
function d = calculate_distortion(X, thresholds)
    d = 0;
    for i=1:length(thresholds)-1

        if thresholds(i) < 0 && thresholds(i+1) < 0
            ti_1 = -thresholds(i+1);
            ti = -thresholds(i);
            xi = -X(i);
            if ti ~= inf
                d = d + 1/2*(exp(-ti_1) * ( ti_1^2 - 2*(ti_1+1)*xi ...
                    + 2*ti_1 + xi^2 + 2 ) ...
                    + exp(-ti) * ( xi*(2*ti - xi + 2) - ti*(ti+2) - 2 ) );
            else
                d = d + 1/2*exp(-ti_1)*( -2*(ti_1+1)*xi + ti_1*(ti_1+2) ...
                    + xi^2 + 2);
            end
        elseif thresholds(i) < 0 && thresholds(i+1) > 0
            ti = thresholds(i+1);
            d = d + 2*(1- 1/2*(ti*(ti+2)+2)*exp(-ti));
        else
            ti_1 = thresholds(i);
            ti = thresholds(i+1);
            xi = X(i);
            if ti ~= inf
                d = d + 1/2*(exp(-ti_1) * ( ti_1^2 - 2*(ti_1+1)*xi + 2*ti_1 ...
                    + xi^2 + 2 ) ...
                    + exp(-ti) * ( xi*(2*ti - xi + 2) - ti*(ti+2) - 2 ) );
            else
                d = d + 1/2*exp(-ti_1)*( -2*(ti_1+1)*xi + ti_1*(ti_1+2) ...
                    + xi^2 + 2);
            end
        end
    end
end