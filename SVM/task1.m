%% Initialise
close all
clear
clc
tic

%% Load variables and Standardise data
load train.mat
%norm_train_data = [- 1 -1 1 1 ; -1 1 -1 1];
%train_label = [-1 ; 1 ; 1 ; -1];
norm_train_data = strd(train_data);

% SVM and Quadprog variables (vary this section according to need)
threshold = 10^-4;              %  values below this threshold are considered to be zero
C = 100;                        % 10^6 for hard margin
H_type = 'rbf';                % 'linear', 'polynomial' 'tanh' 'rbf' only
p = 10;                          % polynomial power or rbf sigma

%% Task 1 - TRAIN
disp(['For ', H_type, ' kernel with C = ', num2str(C)])

% Calcuate kernel matrix and gram matrx
[H, G] = findH(norm_train_data, train_label, H_type, p, threshold);

% Calculate alpha from Quadprog
[alpha, s_vectors_idx] = function_quadprog(train_label, C,threshold, H);

% Calculate w and b in optimal hyperplane
[w,b] = get_wb(norm_train_data, train_label, alpha, s_vectors_idx, H_type, p);


% Save workspace variables for task 2
save('discriminant_variables');
disp(['Discriminant variables saved', newline, 'Task 1 - train ended']);

disp([newline, 'Starting Task 2 - test'])
run task2.m

toc




