% inputs: weight = weight matrix of dimensions (Features x 1)
%         bias = bias value 
%         data = matrix of normalised data (Features x N)
%         label = coressponding labels of data (N x 1)
%         type = indicates what type of kernel to use
%         alpha = alpha matrix (N x 1)
% outputs: a = accuracy of SVM

function [a, prediction] = getacc(weight, bias, data, label, type, alpha, train_data, train_label, p)
switch type
    case 'linear'
        N = size(data,2);
        mat = zeros(N,1);
        prediction = zeros(N,1);
        for i = 1:N
            mat(i,1) = (weight'*data(:,i) + bias) * label(i,1);
            if mat(i,1) > 0
               prediction(i,1) = 1;  
            else
               prediction(i,1) = -1; 
            end
        end
        a = sum(logical(mat > 0)) / N * 100;
        
        
    case 'polynomial'
        M = size(data,2);
        N = size(train_data,2);
        for j = 1:M         %
            mat = 0;
            for i = 1:N     %
                mat = mat + alpha(i,:) * train_label(i,:) * (data(:,j)' * train_data(:,i) + 1) ^ p;
            end
            gx(j) = mat + bias;
        end
        
        for i = 1:M
            if gx(i) > 0
               prediction(i,1) = 1;  
            else
               prediction(i,1) = -1; 
            end
        end
        
        a = sum(logical((gx.* label') > 0)) / M * 100;
        
    case 'tanh'
        M = size(data,2);
        N = size(train_data,2);
        for j = 1:M         %
            mat = 0;
            for i = 1:N     %
                mat = mat + alpha(i,:) * train_label(i,:) * tanh(data(:,j)' * train_data(:,i) - 1);
            end
            gx(j) = mat + bias;
        end
        
        for i = 1:M
            if gx(i) > 0
               prediction(i,1) = 1;  
            else
               prediction(i,1) = -1; 
            end
        end
        
        a = sum(logical((gx.* label') > 0)) / M * 100;

        
    case 'rbf'
        M = size(data,2);
        N = size(train_data,2);
        for j = 1:M         %
            mat = 0;
            for i = 1:N     %
                mat = mat + alpha(i,:) * train_label(i,:) * exp((-1 * norm(data(:,j) - train_data(:,i))) / (p ^ 2));
            end
            gx(j) = mat + bias;
        end
        
        for i = 1:M
            if gx(i) > 0
               prediction(i,1) = 1;  
            else
               prediction(i,1) = -1; 
            end
        end
        
        a = sum(logical((gx.* label') > 0)) / M * 100;
end



