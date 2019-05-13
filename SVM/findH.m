% inputs: data = preprocessed data matrix (Features x N)
%         label = corresponding labels of data (N x 1)
%         type = indicates what type of kernel to use
%         p = power of polynomial. only used for polynomial kernel
%         thres = values below this threshold are considered to be zero
% outputs: matrix2 = matrix H for quadprog function
%          gram_mat = K, gram matrix
function [matrix2,gram_mat] = findH(data, label, type, p, thres)
[M, N] = size(data);
matrix2 = zeros(M,N);
gram_mat = zeros(M,N);

switch type
    case 'linear'
        disp('Computing H (Linear)...');
        for i = 1:N
            for j = 1:i
                gram_mat(i,j) = (data(:,i))' * data(:,j);
                matrix2(i,j) = label(i) * label(j) * gram_mat(i,j);
                gram_mat(j,i) = gram_mat(i,j);
                matrix2(j,i) = matrix2(i,j);
            end
        end
       
    case 'polynomial'
        disp(['Computing H (Polynomial p = ', num2str(p) ,  ')...']);
        for i = 1:N
            for j = 1:i
                gram_mat(i,j) = ((data(:,i))' * data(:,j) + 1)^p;
                matrix2(i,j) = label(i) * label(j) * gram_mat(i,j) ;
                gram_mat(j,i) = gram_mat(i,j);
                matrix2(j,i) = matrix2(i,j);
            end
        end
        
        case 'tanh'
        disp('Computing H (Hyperbolic tangent)');
        for i = 1:N
            for j = 1:i
                gram_mat(i,j) = tanh((data(:,i))' * data(:,j) - 1);
                matrix2(i,j) = label(i) * label(j) * gram_mat(i,j) ;
                gram_mat(j,i) = gram_mat(i,j);
                matrix2(j,i) = matrix2(i,j);
            end
        end
        
        
    case 'rbf'
        disp(['Computing H (RBF sigma = ', num2str(p) ,  ')...']);
        for i = 1:N
            for j = 1:i
                gram_mat(i,j) = exp((-1 * norm(data(:,i) - data(:,j))) / (p ^ 2));
                matrix2(i,j) = label(i) * label(j) * gram_mat(i,j) ;
                gram_mat(j,i) = gram_mat(i,j);
                matrix2(j,i) = matrix2(i,j);
            end
        end
 
    otherwise
        error('please select a valid kernal type');
            
end   % switch end
disp('H matrix calculated');
mercer(gram_mat, thres);

end