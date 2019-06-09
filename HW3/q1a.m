%% Clear all variables and close all
close all
clear
clc
syms x y;
sigma = 0.1;
y = 1.2*sin(pi*x)-cos(2.4*pi*x);
%% Initialise equations and values
training_set_input(:) = -1.6:0.08:1.6;
training_set_output(1,:) = 0.3*randn(1,41) + eval(subs(y,x,training_set_input(1,:)));

test_set_input(:) = -1.6:0.01:1.6;
test_set_output(1,:) = eval(subs(y,x,test_set_input(1,:)));


%% Calculate interpolation matrix and weights
for i = 1:41
    for j = 1:41
        i_mat(i,j) = exp( ((training_set_input(1,i) - training_set_input(1,j))^2)    /  (-2*(sigma^2))     );
    end
end
w = inv(i_mat) * training_set_output';
for i = 1:41
    e_RBF(i,1) = exp(      (x-training_set_input(1,i))^2     /          (-2*(sigma^2))     );
end
fx = dot(w,e_RBF);
result = eval(subs(fx,x,test_set_input(1,:)));
%% Plot test set simulation
figure
hold on 
plot(training_set_input,training_set_output,'m-')
plot(test_set_input,test_set_output,'k-')
xlabel('x'); ylabel('y'); title('Graph of y against x (Exact Interpolation)'); 
plot(test_set_input,result,'b-','Linewidth',1.4);
grid;
legend('Training set (with noise)', 'Test set (without noise)','Approximated function');
%% Find sum of squared error (performace)
mse_test = mean(((result-test_set_output).^2),2);
training_result = eval(subs(fx,x,training_set_input(1,:)));
mse_train = mean(((training_result-training_set_output).^2),2);
