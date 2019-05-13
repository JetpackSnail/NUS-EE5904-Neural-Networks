%% Task 3 - EVALUATE
load eval.mat
load discriminant_variables.mat
norm_eval_data = strd(eval_data);
[eval_acc, eval_predicted] = getacc(w, b, norm_eval_data,eval_label, H_type, alpha, norm_train_data, train_label, p);
disp('Kernel used: RBF with C = 100 and Sigma = 10');
disp(['Accuracy of SVM for evaluation set is ', num2str(round(eval_acc,2)), '%']);
