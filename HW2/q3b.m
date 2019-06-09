%%
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

training_set = cat(2,train_ship,train_deer);
valid_set = cat(2,valid_ship,valid_deer);

training_set_label = cat(2,zeros(1,450),ones(1,450));
valid_set_label = cat(2,zeros(1,50),ones(1,50));

global_mean = sum(training_set,1)/1024;
variance = var(training_set,1,1);

for i = 1:1024
    newtraining(i,:) = (training_set(i,:) - global_mean);
end
newtraining = newtraining./variance;

x = newtraining;
t = training_set_label;
net = perceptron;
net.performFcn = 'mse';
error = 1;
i = 1;

while error ~= 0
    [net,y,e] = adapt(net,x,t);
    disp(i);
    error = mse(e);
    meane(:,i) = mse(e);
    i = i + 1;
    disp(error);
end

view(net)
y = net(x);

correct = 0;
for i = 1:900
    if y(1,i) == training_set_label(1,i)
        correct = correct + 1;
    end
end
accuracy = correct/900;


y1 = sim(net,valid_set);
correct1 = 0;
for i = 1:100
    if y1(1,i) == valid_set_label(1,i)
        correct1 = correct1 + 1;
    end
end
accuracy1 = correct1/100;





toc








%%

function matrix = getfiles(type)
    myFolder = strcat('',type,'\');
    filePattern = fullfile(myFolder, '*.jpg');
    theFiles = dir(filePattern);

    for k = 1 : length(theFiles)
        disp(k)
        baseFileName = theFiles(k).name;
        picfilename = strcat(myFolder,baseFileName);
        pic = reshape(rgb2gray(imread(picfilename)),[1024 1]);
%         if type == 'deer'
%             pic = vertcat(ones(1),pic,ones(1)); %#ok<*AGROW>
%         else
%             pic = vertcat(ones(1),pic,zeros(1));
%         end
%         if type == 'deer'
%             pic = vertcat(ones(1),pic); %#ok<*AGROW>
%         else
%             pic = vertcat(ones(1),pic);
%         end
        matrix(:,k) = pic;
    end
end
