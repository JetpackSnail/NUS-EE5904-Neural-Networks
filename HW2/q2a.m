clear 
clc
close all
tic

syms x y;
y = 1.2*sin(pi*x)-cos(2.4*pi*x);

training_set_input(:) = -1.6:0.05:1.6;
training_set_output(1,:) = eval(subs(y,x,training_set_input(1,:)));

test_set_input(:) = -1.6:0.01:1.6;
test_set_output(1,:) = eval(subs(y,x,test_set_input(1,:)));

desired_input(:) = -3:0.05:3;
desired_output(:) = eval(subs(y,x,desired_input(1,:)));


%
for n = [1:10,20,50,100]
    [ net, accu_train, accu_val ] = train_seq(n, training_set_input, training_set_output, 65, 0, 150);
    disp(n)
    results = sim(net, -3:0.01:3);
    figure
    plot(training_set_input,training_set_output,'rx') %training output
    hold on
    plot(-3:0.01:3,results(1,:),'b','LineWidth',1.5);                %mlp output
    plot(desired_input,desired_output,'k-.');       %desired output
    line([-1.6 -1.6], [-2.5 2.5],'Color','magenta', 'LineStyle','--');
    line([1.6 1.6], [-2.5 2.5],'Color','magenta', 'LineStyle','--');
    legend('Training Output', 'MLP Output', 'Desired Output', 'Limits');
    title(strcat("1-", num2str(n), "-1 on sequential mode"));
    xlabel('x');
    ylabel('y');
    grid
end

toc

function [ net, accu_train, accu_val ] = train_seq( n, images, labels, train_num, val_num, epochs )
%% Construct a 1-n-1 MLP and conduct sequential training.
%
% Args:
% n: int, number of neurons in the hidden layer of MLP.
% images: matrix of (image_dim, image_num), containing possibly preprocessed image data as input.
% labels: vector of (1, image_num), containing corresponding label of each image.
% train_num: int, number of training images.
% val_num: int, number of validation images.
% epochs: int, number of training epochs.


% Returns:
% net: object, containing trained network.
% accu_train: vector of (epochs, 1), containing the accuracy on training set of each eopch during training
% accu_val: vector of (epochs, 1), containing the accuracy on validation set of each eopch during training.

%% 1. Change the input to cell array form for sequential training
images_c = num2cell(images, 1);
labels_c = num2cell(labels, 1);

%% 2. Construct and configure the MLP
net = fitnet(n);
net.divideFcn = 'dividetrain'; % input for training only
net.performParam.regularization = 0.25; % regularization strength
net.trainFcn = 'traingdx'; % 'trainrp' 'traingdx'
net.trainParam.epochs = epochs;
net.inputWeights{1,1}.learnParam.lr = 0.003;
net.layerWeights{2,1}.learnParam.lr = 0.003;
net.biases{1}.learnParam.lr = 0.003;
net.biases{2}.learnParam.lr = 0.003;
accu_train = zeros(epochs,1); % record accuracy on training set of each epoch
accu_val = zeros(epochs,1); % record accuracy on validation set of each epoch

%% 3. Train the network in sequential mode
for i = 1 : epochs
    display(['Epoch: ', num2str(i)])
    idx = randperm(train_num); % shuffle the input
    net = adapt(net, images_c(:,idx), labels_c(:,idx));
    pred_train = round(net(images(:,1:train_num))); % predictions on training set
    accu_train(i) = 1 - mean(abs(pred_train-labels(1:train_num)));
    pred_val = round(net(images(:,train_num+1:end))); % predictions on validation set
    accu_val(i) = 1 - mean(abs(pred_val-labels(train_num+1:end)));
    disp(sim(net,0))
end

end