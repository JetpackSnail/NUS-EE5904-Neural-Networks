%% Initialise

load discriminant_variables.mat
load test.mat

if (H_type == string('polynomial'))
    disp(['Testing ', H_type, ' kernel with C = ', num2str(C), ' (p = ', num2str(p), ')'])
end

if (H_type == string('linear'))
    disp(['Testing ', H_type, ' kernel with C = ', num2str(C)])
end

if (H_type == string('tanh'))
    disp(['Testing ', H_type, ' kernel with C = ', num2str(C)])
end

disp(['Note: the SVM can be configured in task1.m', newline, '..........................................'])


%% Task 2 - TEST
norm_test_data = strd(test_data);
[train_acc, train_predicted] = getacc(w, b, norm_train_data,train_label, H_type, alpha, norm_train_data, train_label, p);
[test_acc, test_predicted] = getacc(w, b, norm_test_data,test_label, H_type, alpha, norm_train_data, train_label, p);

disp(['Accuracy of SVM for training set is ', num2str(round(train_acc,2)), '%']);
disp(['Accuracy of SVM for testing set is ', num2str(round(test_acc,2)), '%']);
disp('Task 2 ended');


