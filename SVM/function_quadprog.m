% inputs: label = corresponding labels of data (N x 1)
%         C = hard margin or soft margin variable
%         threshold = values below this threshold will be zero in matrix alpha
%         H = matrix H for quadprog (N x N)
% outputs: alpha = alpha matrix (N x 1)
%          support_vector_idx = indexes of inputs that are support vectors
function [alpha, support_vector_idx] = function_quadprog(label,C,threshold,H)
disp('Computing Alpha with Quadprog...');
samples = size(H,1);
f = -ones(samples,1);
A = [];
b = [];
Aeq = label';
beq = 0;
lb = zeros(samples,1);
ub = ones(samples,1) * C;
x0 = [];
options = optimset('LargeScale','off','MaxIter',1000);
alpha = quadprog(H,f,A,b,Aeq,beq,lb,ub,x0,options);

rounded_alpha = find(alpha < threshold);
alpha(rounded_alpha) = 0; %#ok<FNDSB>

support_vector_idx = find(alpha>0 & alpha<C);
disp('Quadprog done');
end