dataset = [30 0 10 0; 30 0 70 0; 30 1 20 0; 30 1 80 1; 60 0 40 0; 60 0 60 1
     60 1 50 0; 60 1 60 1];

X = dataset(:, 1:3);
lables = dataset(:, 4);
tree = build_tree(X, lables);

x1 = input('Enter the value of x1: ');
x2 = input('Enter the value of x2: ');
x3 = input('Enter the value of x3: ');

predicted_class = predict(tree, x1, x2, x3);
disp(['The predicted class is : ' num2str(predicted_class)]);

function output = predict(decision_tree, x1, x2, x3)
    input_vector = [x1 x2 x3];
    t = decision_tree;
    while true
        if ~isempty(t.label)
            output = t.label;
            break;
        end
        deciding_feature_index = t.xi;
        if all(t.feature_split_kind == 'thresh')
            if input_vector(deciding_feature_index) > t.split_threshold
                t = t.child(2);
            else
                t = t.child(1);
            end
        else
            if input_vector(deciding_feature_index) == t.unique_values(1)
                t = t.child(1);
            else
                t = t.child(2);
            end
        end
        input_vector(deciding_feature_index) = [];
    end
end

function tree = build_tree(features, c)

    tree = struct('xi', 0, 'child', [], 'feature_split_kind', '' ...
        , 'split_threshold', [], 'unique_values', [], 'label', []);

    if isempty(features) || length(unique(c)) == 1
        if ~isempty(c)
            if sum(c) > length(c)/2
                tree.label = 1;
            else
                tree.label = 0;
            end
        end
        return
    end
    
    [l, lc, r, rc, feature_number, threshold] = find_best_feature ...
        (features, c);
    
    disp(['i = ' num2str(feature_number) '  threshold = ' threshold]);
    disp('left');
    disp([l lc]);
    disp('right');
    disp([r rc]);

    l_tree = [];
    r_tree = [];

    if feature_number == 0 
        if sum(c) > length(c)/2
            tree.label = 1;
        else
            tree.label = 0;
        end
        return;
    end

    l_tree = build_tree(l, lc);
    r_tree = build_tree(r, rc);

    if length(unique(features(:, feature_number))) <= 2
        tree = struct('xi', feature_number, 'child', [l_tree r_tree], ...
            'feature_split_kind', 'binary', 'split_threshold', threshold ...
            , 'unique_values', unique(features(:, feature_number)) ...
            , 'label', []);
    else
        tree = struct('xi', feature_number, 'child', [l_tree r_tree], ...
            'feature_split_kind', 'thresh', 'split_threshold', threshold ...
            , 'unique_values', [], 'label', []);
    end

end

function [left, left_c, right, right_c, feature_number, threshold] ...
    = find_best_feature(features, c)
    
    class1_count = sum(c);
    class0_count = length(c) - sum(c);
    p0 = class0_count/length(c);
    p1 = class1_count/length(c);
    max_IGR = 0;
    threshold = [];

    if class1_count ~= 0 && class0_count ~= 0
        Hc = p0*log2(1/p0) + p1*log2(1/p1);
    else
        return;
    end

    for i = 1:length(features(1, :))
        feature = features(:, i);
        uniq = unique(feature);
        Hcx = 0;
        temp_right = [];
        temp_left = [];
        temp_right_c = [];
        temp_left_c = [];

        if length(uniq) == 2
            for k = 1:2
                counts = [0 0];
                
                for j = 1:length(c)
                    delete_current_feature = features(j, :);
                    delete_current_feature(:, i) = [];
                    
                    if feature(j) == uniq(k)
                        if k == 1
                            temp_left = [temp_left; ...
                                delete_current_feature];
                            temp_left_c = [temp_left_c; c(j)];
                        else
                            temp_right = [temp_right; ...
                                delete_current_feature];
                            temp_right_c = [temp_right_c; c(j)];
                        end
                        label = c(j) + 1;
                        counts(label) = counts(label) + 1;
                    end
                end
                p = counts / sum(counts);
                if p(1) == 1 || p(2) == 1
                    Hx = 0;
                else
                    Hx = (p(1)*log2(1/p(1)) + p(2)*log2(1/p(2)));
                end
                Hcx = Hcx + Hx * (sum(counts)/length(c));
            end
            I = Hc - Hcx;
            IGR = I / Hc;
            if IGR > max_IGR
                max_IGR = IGR;
                right = temp_right;
                left = temp_left;
                right_c = temp_right_c;
                left_c = temp_left_c;
                feature_number = i;
                threshold = [];
            end
        else
            IGR_threshold = zeros(1, length(uniq)-1);
            for k = 1:length(uniq)-1
                temp_right = [];
                temp_left = [];
                temp_right_c = [];
                temp_left_c = [];
                counts1 = [0 0];
                counts2 = [0 0];
                for j = 1:length(c)
                    delete_current_feature = features(j, :);
                    delete_current_feature(:, i) = [];
                    if feature(j) > uniq(k)
                        temp_right = [temp_right; delete_current_feature];
                        temp_right_c = [temp_right_c; c(j)];
                        label = c(j) + 1;
                        counts2(label) = counts2(label) + 1;
                    else
                        temp_left = [temp_left; delete_current_feature];
                        temp_left_c = [temp_left_c; c(j)];
                        label = c(j) + 1;
                        counts1(label) = counts1(label) + 1;
                    end
                end
                
                p1 = counts1 / sum(counts1);
                p2 = counts2 / sum(counts2);
                if any(p1 == 1)
                    Hx1 = 0;
                else
                    Hx1 = (p1(1)*log2(1/p1(1)) + p1(2)*log2(1/p1(2)));
                end
                if any(p2 == 1)
                    Hx2 = 0;
                else
                    Hx2 = (p2(1)*log2(1/p2(1)) + p2(2)*log2(1/p2(2)));
                end
                Hcx = (Hx1 * sum(counts1) ...
                    + Hx2 * sum(counts2)) / length(c);
                I = Hc - Hcx;
                IGR = I / Hc;
                IGR_threshold(k) = IGR;

                if IGR >= max_IGR
                    max_IGR = IGR;
                    right = temp_right;
                    left = temp_left;
                    right_c = temp_right_c;
                    left_c = temp_left_c;
                    feature_number = i;
                end
            end
            max_threshold = IGR_threshold == max(IGR_threshold);
            threshold = uniq(max_threshold);
        end 
    end
    
    if max_IGR == 0
        feature_number = 0;
    end
end