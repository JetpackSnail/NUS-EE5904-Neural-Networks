clear 
clc
close all
tic

groupnumber = mod(08,3);

ship = double(getfiles('ship'));
deer = double(getfiles('deer'));
total = [ship deer];

train_ship = ship(:,1:450);
train_deer = deer(:,1:450);
valid_ship = ship(:,451:500);
valid_deer = deer(:,451:500);

training_set = [train_ship train_deer];
valid_set = [valid_ship valid_deer];

training_set_label = [zeros(1,450),ones(1,450)];
valid_set_label = [zeros(1,50),ones(1,50)];
total_label = [zeros(1,500),ones(1,500)];
for n = [1,2,3,5,10,15,20]
    [ net, accu_train, accu_val ] = train_seq(n, training_set, training_set_label, 900, 0, 550);
    
    y = round(net(training_set));
    t = training_set_label;
    correct = 0;
    for i = 1:900
        if y(1,i) == training_set_label(1,i)
            correct = correct + 1;
        end
    end
    accuracy(1,n) = correct/900;
    accuracy(2,n) = n;
    perf = perform(net,t,y);
    
    
    
    y1 = round(sim(net,valid_set));
    correct1 = 0;
    for i = 1:100
        if y1(1,i) == valid_set_label(1,i)
            correct1 = correct1 + 1;
        end
    end
    accuracy1(1,n) = correct1/100;
    accuracy1(2,n) = n;
end

toc


function [ net, accu_train, accu_val ] = train_seq( n, images, labels, train_num, val_num, epochs )
%% Construct a 1-n-1 MLP and conduct sequential training.
%
% Args:
% n:            int, number of neurons in the hidden layer of MLP.
% images:       matrix of (image_dim, image_num), containing possibly preprocessed image data as input.
% labels:       vector of (1, image_num), containing corresponding label of each image.
% train_num:    int, number of training images.
% val_num:      int, number of validation images.
% epochs:       int, number of training epochs.
%
% Returns:
% net:          object, containing trained network.
% accu_train:   vector of (epochs, 1), containing the accuracy on training set of each eopch during training
% accu_val:     vector of (epochs, 1), containing the accuracy on validation set of each eopch during trainig.
%% 1. Change the input to cell array form for sequential training
images_c = num2cell(images, 1);
labels_c = num2cell(labels, 1);
%% 2. Construct and configure the MLP
net = patternnet(n);
net.divideFcn = 'dividetrain';              % input for training only
net.performParam.regularization = 0.1;     % regularization strength
net.trainFcn = 'trainrp';                  % 'trainrp' 'traingdx'
net.trainParam.epochs = epochs;
net.inputWeights{1,1}.learnParam.lr = 0.003;
net.layerWeights{2,1}.learnParam.lr = 0.003;
net.biases{1}.learnParam.lr = 0.002;
net.biases{2}.learnParam.lr = 0.002;
accu_train = zeros(epochs,1);               % record accuracy on training set of each epoch
accu_val = zeros(epochs,1);                 % record accuracy on validation set of each epoch
%% 3. Train the network in sequential mode
for i = 1 : epochs
    display(['Epoch: ', num2str(i)])
    idx = randperm(train_num);                          % shuffle the input
    net = adapt(net, images_c(:,idx), labels_c(:,idx));
    pred_train = round(net(images(:,1:train_num)));     % predictions on training set
    accu_train(i) = 1 - mean(abs(pred_train-labels(1:train_num)));
    pred_val = round(net(images(:,train_num+1:end)));   % predictions on validation set
    accu_val(i) = 1 - mean(abs(pred_val-labels(train_num+1:end)));
    disp(accu_train(i))
end
end
function matrix = getfiles(type)
    myFolder = strcat('',type,'\');
    filePattern = fullfile(myFolder, '*.jpg');
    theFiles = dir(filePattern);

    for k = 1 : length(theFiles)
        disp(k)
        baseFileName = theFiles(k).name;
        picfilename = strcat(myFolder,baseFileName);
        pic = reshape(rgb2gray(imread(picfilename)),[1024 1]);

        matrix(:,k) = pic;
    end
end