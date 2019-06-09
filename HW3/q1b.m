%% Clear all variables and close all
close all
clear
clc
syms x y;
y = 1.2*sin(pi*x)-cos(2.4*pi*x);

%% Initialise equations and values
training_set_input(:) = -1.6:0.08:1.6;
training_set_output(1,:) = 0.3*randn(1,41) + eval(subs(y,x,training_set_input(1,:)));

test_set_input(:) = -1.6:0.01:1.6;
test_set_output(1,:) = eval(subs(y,x,test_set_input(1,:)));

%% Randomly select 20 centers among sampling(training) points and cluster
idx = randperm(41);
for i = 1:20
    init_center(1,i) = training_set_input(1,(idx(1,i)));  
end

sigma = (max(init_center)-min(init_center)) / (sqrt(2*20));

%% Calculate interpolation matrix and weights
for i = 1:41
    for j = 1:20
        i_mat(i,j) = exp( ((training_set_input(1,i) - init_center(1,j))^2)    /  (-2*(sigma^2))     );
    end
end
w = pinv(i_mat'*i_mat) * i_mat' * training_set_output';
for i = 1:20
    e_RBF(i,1) = exp(      (x-init_center(1,i))^2     /          (-2*(sigma^2))     );
end
fx = dot(w,e_RBF);
result = eval(subs(fx,x,test_set_input(1,:)));

%% Plot test set simulation
figure
hold on 
plot(training_set_input,training_set_output,'m-')
plot(test_set_input,test_set_output,'k-')
xlabel('x'); ylabel('y'); title('Graph of y against x (Random centres)');
plot(test_set_input,result,'b-', 'Linewidth',1.4);
grid;
legend('Training set (with noise)', 'Test set (without noise)','Approximated function');

%% Find sum of squared error (performace)
mse_test = mean(((result-test_set_output).^2),2);
training_result = eval(subs(fx,x,training_set_input(1,:)));
mse_train = mean(((training_result-training_set_output).^2),2);

%%
function matrix = clus(center,training_set_input)       % clustering function
row = size(center,1);
for i = 1:20
    for j = 1:161
        dis(i,j) = abs(training_set_input(1,j)-center(row,i));
    end
end
[min_dis,cluster] = min(dis,[],1);
row = row + 1;
center = cat(1,center,zeros(1,20));
for i = 1:20        % cluster
    counter = 0;
    for j = 1:161   % data points
        if i == cluster(1,j)
            center(row,i) = training_set_input(1,j) + center(row,i);    % find sum in cluster i
            counter = counter + 1;
        end
    end
    center(row,i) = (center(row,i))/counter;    % find mean(center) of i
end
if ~(isequal(center(row-1,:),center(row,:)))
    center = clus(center,training_set_input);
end
matrix = center(end,1:20);
end


