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

training_set = [train_ship train_deer];
valid_set = [valid_ship valid_deer];
training_set_label = [zeros(1,450),ones(1,450)];
valid_set_label = [zeros(1,50),ones(1,50)];

x = training_set;
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
perf = perform(net,t,y);


t1 = valid_set_label;
y1 = sim(net,valid_set);
correct1 = 0;
for i = 1:100
    if y1(1,i) == valid_set_label(1,i)
        correct1 = correct1 + 1;
    end
end
accuracy1 = correct1/100;
perf1 = perform(net,t1,y1);

toc

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


% 
% [dim, num_input] = size(training_set);
% 
% rate = 0.001;                      % change this for learning rate
% counter = 1;
% weights(:)= rand(1,dim);     % change this for random weights
% %%
% %classified = false;
% 
% for index = 1:1000
%     %while not (classified)
%         %classified = true;
%         for i = 1 : num_input
%             y = dot(weights(counter,1:dim), training_set(1:dim , i)) >= 0;
%             if i >= 1 && i <= 450
%                 label = 0;
%             else
%                 label = 1;
%             end  
%             error = label - y;
%             if (not (error == 0))
%                 %classified = false;
%                 weights(counter+1, 1:dim) = weights(counter, 1:dim) + (rate*error*training_set(1:dim , i))';
%                 counter = counter + 1;
%             end
%         end
%         disp(index)
%     %end 
% end
% 
% correct = 0;
% trained_weights = weights(size(weights,1),1:1025);
% for i = 1 : num_input
%     y(1,i) = dot(trained_weights(1,1:dim), training_set(1:dim , i)) >= 0;
%     if i >= 1 && i <= 450
%         label = 0;
%     else
%         label = 1;
%     end
%     if y(1,i) == label
%         correct = correct + 1;
%     end
% end
% trainingset_accuracy = correct/900;
% 
% for i = 1 : 100
%     y_valid(1,i) = dot(trained_weights(1,1:dim), valid_set(1:dim-1 , i)) >= 0;
%     if y(1,i) == valid_set(1026,i)
%         correct = correct + 1;
%     end
% end
