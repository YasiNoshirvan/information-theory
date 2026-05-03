%% Calculate For N=10

% Calculating probabilities
probabilities_1 = calculate_probabilities(10);

% Calculating entropy
entropy_1 = calculate_entropy(probabilities_1);

% Calculating Huffman code lengths
huffman_code_lengths_1 = huffman_code_lengths(probabilities_1);

% Calculating the average number of bits per symbol
average_bits_1 = sum(probabilities_1 * huffman_code_lengths_1);

fprintf('ENTROPY RATE VALUE FOR N=10 IS %f\n', entropy_1);
fprintf('THE AVERAGE NUMBER OF BITS PER SYMBOL FOR N=10 IS %f\n', average_bits_1);

%% Calculate For N=100

% Calculating probabilities
probabilities_2 = calculate_probabilities(100);

% Calculating entropy
entropy_2 = calculate_entropy(probabilities_2);

% Calculating Huffman code lengths
huffman_code_lengths_2 = huffman_code_lengths(probabilities_2);

% Calculating the average number of bits per symbol
average_bits_2 = sum(probabilities_2 * huffman_code_lengths_2);

fprintf('\nENTROPY RATE VALUE FOR N=100 IS %f\n', entropy_2);
fprintf('THE AVERAGE NUMBER OF BITS PER SYMBOL FOR N=100 IS %f\n', average_bits_2);

%% Calculate For N=1000

% Calculating probabilities
probabilities_3 = calculate_probabilities(1000);

% Calculating entropy
entropy_3 = calculate_entropy(probabilities_3);

% Calculating Huffman code lengths
huffman_code_lengths_3 = huffman_code_lengths(probabilities_3);

% Calculating the average number of bits per symbol
average_bits_3 = sum(probabilities_3 * huffman_code_lengths_3);

fprintf('\nENTROPY RATE VALUE FOR N=1000 IS %f\n', entropy_3);
fprintf('THE AVERAGE NUMBER OF BITS PER SYMBOL FOR N=1000 IS %f\n', average_bits_3);
%% Normalization

% For the stationary source, we can compute probabilities with p(n) 1/1+n^3, where (n = 0, 1,..., N-1).
% We need to normalize these probabilities to make sure that they sum up to 1. 
% We can use this equation to normalize the probabilities in order to achieve our goal.

%% Defining a function which calculates the normalized probabilities
function normalized_probabilities = calculate_probabilities(N)
    probabilities = zeros(1, N);

    for n = 1:N
        probabilities(n) = 1 / (1 + (n-1)^3);
    end

    normalization_constant = sum(probabilities);
    normalized_probabilities = probabilities / normalization_constant;
end

%% Entropy Rate

% After normalizing the probabilities, we can determine the Entropy Rate With this equation.

function entropy = calculate_entropy(probabilities)
    entropy = -sum(probabilities .* log2(probabilities));
end

%% Average number of bits

% In each iteration we choose the two minimum probabilities, and combine
% them into a node with the sum of their probabilities


function length_encoded_words = huffman_code_lengths(probs)
    
    encoded_words = configureDictionary("string","string");
    probabilities = configureDictionary("string","double");
    index = [1:length(probs)];
    i = 1;
    for p = probs
        probabilities(string(index(i))) = p;
        i = i + 1;
    end

    while length(probabilities.keys)~=1
        [min1_value, min1_prob] = findMin(probabilities);
        probabilities = remove(probabilities, min1_prob);

        for w = min1_prob.split(",")
            if isKey(encoded_words, w)
                encoded_words(w) = "0" + encoded_words(w);
            else
                encoded_words(w) = "0";
            end
        end

        [min2_value, min2_prob] = findMin(probabilities);
        probabilities = remove(probabilities, min2_prob);

        for w = min2_prob.split(",")
            if isKey(encoded_words, w)
                encoded_words(w) = "1" + encoded_words(w);
            else
                encoded_words(w) = "1";
            end
        end

        probabilities(min1_prob+","+min2_prob) = min1_value + min2_value;
    end
    length_encoded_words = strlength(encoded_words.values);
    length_encoded_words = flip(length_encoded_words);
end

function [value, word] = findMin(array)
    values = array.values;
    words = array.keys;
   
    value = values(1);
    word = words(1);
    for i = 1:length(values)
        if values(i) < value
            value = values(i);
            word = words(i);
        end
    end
end