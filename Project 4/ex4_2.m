%% Question 7
% convert the given sequence to array
binaryString = '1010100010000001101010010111011000101110';
decimalValue = bin2dec(binaryString);
portion_of_key = dec2bin(decimalValue, numel(binaryString) - 1) - '0';

% b = Ax
% we use the final 20 bits of the given seq. as b
b = flip(portion_of_key(21:end))';
A = zeros(20);

index = 40;

% here we calculate the matrix A, for each cell in 'b' we add the 20
% preceding bits to A
for i=1:20
    for j=1:20
        A(i, j) = portion_of_key(index-j);
    end
    index = index - 1;
end

% solving the equations and find x coefficients (primitive polynomial) 
R = rank(gf(A));
[x,v] = gflineq(A,b,2);
disp('Primitive Polynomial of LFSR = ');
disp(x');

primitive = "P(D) = D^20";
for i = 1:20
    if x(i)
        primitive = primitive + " + D^" + (20-i);
    end
end

disp(primitive);

%% Question 8

index = 41;
all_key = [portion_of_key, zeros(1, 20)];

% for each bit we calculate it based on the 20 preceding bits and the
% primitive polynomial from question 7
for i = 41:60
    all_key(i) = mod(flip(all_key(i-20:i-1)) * x, 2);
end

disp('Next 20 bits = ');
disp(all_key(41:60));

