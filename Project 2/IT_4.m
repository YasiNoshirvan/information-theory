% Read the content of the text file
fileID = fopen('warandpeace.txt', 'r');
textData = fscanf(fileID, '%c');
fclose(fileID);

%% Here we preprocess the data (upper casing, removing accents, ...)
words = preprocess(textData);

%% Building a dictionary with words and occurrences of each word
dict = configureDictionary("string","double");
for i = 1:length(words)
    word = words{i};
    if isKey(dict, word)
        dict(word) = dict(word) + 1;
    else
        dict(word) = 1;
    end
end

keys = dict.keys;
counts = dict.values;

%% Calculating entropy rate
entropy_rate = calculate_entropy_rate(counts);
disp('entropy rate = ');
disp(entropy_rate);

% sort the dictionary based on frequency
[sortedCounts, sortedIdx] = sort(counts, 'descend');
sortedKeys = keys(sortedIdx);

%% Encode the data with different values of N=(1000, 2000, ..., 20000)
Ns = 1000:1000:20000;
memory_percentage = zeros(length(Ns), 1);
for i = 1:length(Ns)
    N = Ns(i);
    
    dict_huffman = dictionary(sortedKeys(1:N), sortedCounts(1:N));
    
    % Encoding the first N frequent words with huffman and writing the
    % huffman tree codes in "HUFFMAN.TXT"
    encode_huffman(dict_huffman);

    % this function starts the process of encoding all the given text
    encoded_data = start_encoding(words);

    % save encoded binary data in "ENCODED_DATA.BIN"
    save_encoded_data(encoded_data);
    
    % calculating the percentage of memory usage decrease
    memory_percentage(i) = 1 - (dir('encoded_data.bin').bytes+dir('huffman.txt').bytes) / dir('warandpeace.txt').bytes;

end

% plot the comparison of memory usage for differnet values of N
bar(Ns, memory_percentage);
xlabel('value of N');
ylabel('percentage of compression')

% Functions 

%% this function saves encoded data in binary format in 'encoded_data.bin' 
function save_encoded_data(encoded_data)
    encoded_data = char(encoded_data);
    encoded_data = [encoded_data, repmat('0', 1, 8-mod(strlength(encoded_data), 8))];
    binary_encoded_data = uint8(bin2dec(reshape(encoded_data, 8, []).'));
    fileID = fopen('encoded_data.bin', 'w');
    fwrite(fileID, binary_encoded_data, 'uint8');
    fclose(fileID);
end

%% this function encodes all the given data. First it checks if any word is
% Encoded by huffman and uses it's encoded value, then if it was not in the
% Huffman tree, the word will be encoded with maxlength encoding.
function encoded_data = start_encoding(context)
    encoded_data = '';
    huffman_encoded_words = load_huffman_code();

    for i = 2:length(context)
        if isKey(huffman_encoded_words, context{i})
            encoded_data = encoded_data + huffman_encoded_words(context{i});
        else
            encoded_data = encoded_data + encode_maxlength(context{i});
        end
        
    end
end

%% this function loads the saved huffman tree from 'huffman.txt'
function huffman_encoded_words = load_huffman_code()
    huffman_encoded_words = configureDictionary("string","string");
    fileID = fopen('huffman.txt', 'r');
    while ~feof(fileID)
        line = fscanf(fileID,'%s,%s');
        if strlength(line) == 0
            fclose(fileID);
            return;
        end
        line = split(line, ',');
        huffman_encoded_words(line{1}) = line{2};
    end
    fclose(fileID);
end

%% this function encodes a given word by encoding each of it's characters 
% in 6 bits, and then add the length of encoded word in 8 bits, finally
% it adds a flag bit "1" to the encoded word that shows this is a ml
% encoding
function encoded_word = encode_maxlength(word)
    alphabet = strcat(char(48:57), char(65:90));
    encoded_word = '';

    for j = 1:strlength(word)
        % we use 6 bits because we have 36 characters
        binary_character = dec2bin(find(alphabet == word(j)) - 1, 6);
        encoded_word = strcat(encoded_word, binary_character);
    end
    encoded_word = "1" + dec2bin(length(encoded_word), 8) + encoded_word;
end

%% this function encodes a list of words with huffman tree, in each step
% it extracts the two words with minimum frequency and combines them
% and at the end each word will have a huffman encoding. then the length of
% encoding will be added in 6 bits and finally a flag bit "0" also will
% show that this is a huffman encoding
function encode_huffman(words)
    encoded_words = configureDictionary("string","string");

    fileID = fopen('huffman.txt', 'w'); 

    while length(words.values)~=1
        [min1_value, min1_word] = findMin(words);
        words = remove(words, min1_word);

        for w = min1_word.split(",")
            if isKey(encoded_words, w)
                encoded_words(w) = encoded_words(w) + "0";
            else
                encoded_words(w) = "0";
            end
        end

        [min2_value, min2_word] = findMin(words);
        words = remove(words, min2_word);

        for w = min2_word.split(",")
            if isKey(encoded_words, w)
                encoded_words(w) = encoded_words(w) + "1";
            else
                encoded_words(w) = "1";
            end
        end

        words(min1_word+","+min2_word) = min1_value + min2_value;
    end

    keys = encoded_words.keys;
    values = encoded_words.values;

    max_digits_of_huffman = max(strlength(values));
    length_bits_huffman = ceil(log2(max_digits_of_huffman));
    
    for i = 1:length(keys)
        encoded_words(keys{i}) = "0" + dec2bin(length(values{i}), length_bits_huffman) + values{i};
    end

    keys = encoded_words.keys;
    values = encoded_words.values;

    keys = flip(keys);
    values = flip(values);

    for i = 1:length(encoded_words.keys)
        fprintf(fileID, '%s,%s\n', keys(i), values(i));
    end

    fclose(fileID);
end

%% this function extracts the word with lowest frequency from dictionary
% it is used in huffman algorithm
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

%% this function calculates the entropy rate given frequencies
function entropy_rate = calculate_entropy_rate(counts)
    total_counts = sum(counts);
    entropy_rate = 0;
    for i = 1:length(counts)
        probability = counts(i)/total_counts;
        entropy_rate = entropy_rate - probability * log2(probability);
    end
end

%% this function is used for preprocessing(uppercasing, removing accents
% , removing punctuations, split the text into words)
function words = preprocess(textData)
    % Remove punctuation and convert text to uppercase
    textData = upper(textData);
    accents = {'Á', 'É', 'Í', 'Ó', 'Ú'};
    non_accents = {'A', 'E', 'I', 'O', 'U'};
    
    for i = 1:length(accents)
        textData = regexprep(textData, accents{i}, non_accents{i});
    end
    
    textData = regexprep(textData, '[^0-9A-Z\s]', '');
    textData = regexprep(textData, '\s+', ' ');
    
    % Split the text into words
    words = strsplit(textData);
end