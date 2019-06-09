clear 
clc
close all
tic

groupnumber = mod(08,3);

ship = double(getfiles('ship'));
deer = double(getfiles('deer'));


train_ship = ship(:,1:450);
train_deer = deer(:,1:450);
valid_ship = ship(:,451:500);
valid_deer = deer(:,451:500);

training_set = [train_ship train_deer];
valid_set = [valid_ship valid_deer];

training_set_label = [zeros(1,450),ones(1,450)];
valid_set_label = [zeros(1,50),ones(1,50)];

total = [training_set valid_set];
total_label = [training_set_label,valid_set_label];

trainFcn = 'trainscg';

x = total;
t = total_label;

% Create a Fitting Network
for n = [20]
hiddenLayerSize = n;
net = patternnet(hiddenLayerSize,trainFcn);


% Setup Division of Data for Training, Validation, Testing
net.divideParam.trainRatio = 70/100;
net.divideParam.valRatio = 15/100;
net.divideParam.testRatio = 15/100;
net.performParam.regularization = 0.55;
net.trainParam.epochs = 1000;
% net.inputWeights{1,1}.learnParam.lr = 0.005;
% net.layerWeights{2,1}.learnParam.lr = 0.005;

% Train the Network 
[net,tr] = train(net,x,t);

% Test the Network
y = net(x);
e = gsubtract(t,y);
performance = perform(net,t,y);

y_train = round(sim(net,training_set));
correct = 0;
for i = 1:100
    if y_train(1,i) == training_set_label(1,i)
        correct = correct + 1;
    end
end
accuracy_t(:,n) = correct/100;

y1 = round(sim(net,valid_set));
correct1 = 0;
for i = 1:100
    if y1(1,i) == valid_set_label(1,i)
        correct1 = correct1 + 1;
    end
end
accuracy1 = correct1/100;
aa(:,n) = accuracy1;

figure;
plotperform(tr)
text(2,0.25,strcat("1-", num2str(n), "-1 trainscg with regularization"),'Color','red','FontSize',12);

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
