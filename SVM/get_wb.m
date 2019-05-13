% inputs: data = preprocessed data matrix (Features x N)
%         label = corresponding labels of data (N x 1)
%         alpha = alpha matrix (N x 1)
%         idx = indexes of inputs that are support vectors
%         type = indicates what type of kernel to use
%         p = power of polynomial (used for polynomial kernel only
% outputs: weights
%          bias
function [weights,bias] = get_wb(data, label, alpha, idx, type, p)
switch type
    case 'linear'
        weights = 0;
        for i = 1:size(data,2)
            weights = weights + alpha(i,1) * label(i,1) * data(:,i);
        end
        bias = mean((1 ./ label(idx)') - weights' * data(:,idx));
        
    case 'polynomial'
        b = zeros(size(idx));
        for j = 1:size(idx)
            s_idx = idx(j);
            weights = 0;
            for i = 1:size(data,2)
                weights = weights + alpha(i,:) * label(i,:) * (data(:,s_idx)' * data(:,i) + 1) ^ p;
            end
            b(j) = label(s_idx,:) - weights;
        end
        bias = mean(b);
        
    case 'tanh'
        b = zeros(size(idx));
        for j = 1:size(idx)
            s_idx = idx(j);
            weights = 0;
            for i = 1:size(data,2)
                weights = weights + alpha(i,:) * label(i,:) * tanh(data(:,s_idx)' * data(:,i) - 1);
            end
            b(j) = label(s_idx,:) - weights;
        end
        bias = mean(b);
        
        
    case 'rbf'
        b = zeros(size(idx));
        for j = 1:size(idx)
            s_idx = idx(j);
            weights = 0;
            for i = 1:size(data,2)
                weights = weights + alpha(i,:) * label(i,:) *  exp((-1 * norm(data(:,s_idx) - data(:,i))) / (p ^ 2));
            end
            b(j) = label(s_idx,:) - weights;
        end
        bias = mean(b);
end
end


