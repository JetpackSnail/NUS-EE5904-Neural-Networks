%% Clear all variables and close all
close all
clear
clc
num_cen = 2;
tic

%% Initialise equations and values
load mnist_m.mat 

trainidx = find(train_classlabel == 0 | train_classlabel == 8);
train_classlabel_logic = logical(train_classlabel(:,:) == 0 | train_classlabel(:,:) == 8);

testidx = find(test_classlabel == 0 | test_classlabel == 8);
test_classlabel_logic = logical(test_classlabel(:,:) == 0 | test_classlabel(:,:) == 8);

%% Kmeans clustering and calculate width
[idx, center] = kmeans(train_data',num_cen);
idx = idx';
cen_data = center';

%% Calculate interpolation matrix and weights
close all
counter = 1;
for sigma = [1:1:10, 20:10:100, 200:100:1000, 2000:1000:10000]
%for sigma = [1]
    disp(sigma)
    i_mat = cal_i_mat(train_data, sigma,cen_data);
    i_mat_test = cal_i_mat(test_data, sigma,cen_data);
    
    w = inv(i_mat'*i_mat) * i_mat' * double(train_classlabel_logic)';
    
    TrPred = i_mat * w;
    TePred = i_mat_test * w;
    
    TrLabel = double(train_classlabel_logic);
    TeLabel = double(test_classlabel_logic);
    
    TrAcc = zeros(1,1000);
    TeAcc = zeros(1,1000);
    thr = zeros(1,1000);
    TrN = length(TrLabel);
    TeN = length(TeLabel);
    
    for i = 1:1000
        t = (max(TrPred)-min(TrPred)) * (i-1)/1000 + min(TrPred);
        thr(i) = t;
        TrAcc(i) = (sum(TrLabel(TrPred<t)==0) + sum(TrLabel(TrPred>=t)==1)) / TrN;
        TeAcc(i) = (sum(TeLabel(TePred<t)==0) + sum(TeLabel(TePred>=t)==1)) / TeN;
    end
    
    acc_th(1,counter) = sigma;                      % sigma value
    
    [acc_th(2,counter),thres] = max(TrAcc);         % max training accuracy
    acc_th(3,counter) = thr(1,thres);
    
    [acc_th(4,counter),thres] = max(TeAcc);         % max testing accuracy
    acc_th(5,counter) = thr(1,thres);
    
    counter = counter + 1;
    %figure;
    plot(thr,TrAcc,'.- ',thr,TeAcc,'^-');legend('tr','te','Location','southeast');
    grid
    title(strcat('Accuracy against Threshold (Width = ', " ", num2str(sigma), ")"))
    ylabel("Accuracy"); xlabel("Threshold");
    %saveas(gcf,strcat("c_image/c_",num2str(sigma),".bmp"))
end

figure;
hold on
plot(acc_th(1,:),acc_th(2,:),'-m');
plot(acc_th(1,:),acc_th(4,:),'-k');
legend('Training data','Test data','Location','northeast');
grid
title('Accuracy against Width');
ylabel("Accuracy"); xlabel("Width");
%saveas(gcf,strcat("c_image/c_","acc against thres",".bmp"))

%% Plot centers and mean   
label0idx = find(~train_classlabel_logic == 1);
label1 = train_data(:,trainidx);
label1_mean = mean(label1,2);
label0 = train_data(:,label0idx);
label0_mean = mean(label0,2);

plotimages(cen_data,'Center');          % visualise centers from kmeans
plotimages(label1_mean,'Label 1');      % visualise label 1 mean
plotimages(label0_mean,'Label 0');      % visualise label 0 mean

toc

%% Functions
function plotimages(data,txt)
num_data = size(data, 2);
for i = 1:num_data
    img = reshape(data(:,i),[28 28]);
    figure;
    imshow(img');
    xlabel(txt)
end
end

function matrix = cal_i_mat(data, sigma, train_data)
num_data = size(data,2);
num_cen = size(train_data,2);
matrix = zeros(num_data,num_cen);
for i = 1:num_data
    for j = 1:num_cen
        disp(['For width = ' num2str(sigma) ', calculating (' num2str(i) ',' num2str(j),')'])
        matrix(i,j) = exp (  (norm(data(:,i) - train_data(:,j)))^2  /  (-2*(sigma^2))   )  ;
    end
end
end







% 
% 
% 
% 
% tries = 1;
% center = zeros(row,num_cen);
% 
% temp = clus(center,train_data,tries,num_cen,cluster_label);
% 
% function matrix = clus(center,train_data,tries,num_cen,cluster_label)
% for i = 1:num_cen                      % cluster
%     counter = 0;
%     for j = 1:size(train_data,2)               % data points
%         if i == cluster_label(1,j)
%             center(:,i,tries+1) = train_data(:,j) + center(:,i,tries);    % find sum in cluster i
%             counter = counter + 1;
%         end
%     end
%     center(:,i,tries+1) = (center(:,i,tries+1))/counter;    % find mean(center) of i
% end
% if ~(isequal(center(:,:,tries),center(:,:,tries+1)))
%     tries = tries + 1;
%     center = clus(center,train_data,tries);
% end
% matrix = center(:,2);
% end
% 
% 
% 
% 
% 
% 
% 
% 




% 
% %% Calculate interpolation matrix and weights
% idx = randperm(size(train_data,2));
% idx = idx(1,1:num_cen);
% 
% cen_data = train_data(:,idx);
% cen_label = train_classlabel_logic(:,idx);
% 
% for i = 1:num_cen
%     dist(1,i) = norm(cen_data(:,i));
% end
% sigma_o = (max(dist) - min(dist)) /  (sqrt(2*num_cen));
% 
% %% Calculate performance and plot graphs
% close all
% counter = 1;
% for sigma = [sigma_o, 0.1:0.1:1, 2:1:10, 20:10:100, 200:100:1000, 2000:1000:10000]
%     disp(sigma)
%     i_mat = cal_i_mat(train_data, sigma,cen_data);
%     i_mat_test = cal_i_mat(test_data, sigma,cen_data);
%     
%     w = inv(i_mat'*i_mat) * i_mat' * double(train_classlabel_logic)';
%     
%     TrPred = i_mat * w;
%     TePred = i_mat_test * w;
%     
%     TrLabel = double(train_classlabel_logic);
%     TeLabel = double(test_classlabel_logic);
%     
%     TrAcc = zeros(1,1000);
%     TeAcc = zeros(1,1000);
%     thr = zeros(1,1000);
%     TrN = length(TrLabel);
%     TeN = length(TeLabel);
%     
%     for i = 1:1000
%         t = (max(TrPred)-min(TrPred)) * (i-1)/1000 + min(TrPred);
%         thr(i) = t;
%         TrAcc(i) = (sum(TrLabel(TrPred<t)==0) + sum(TrLabel(TrPred>=t)==1)) / TrN;
%         TeAcc(i) = (sum(TeLabel(TePred<t)==0) + sum(TeLabel(TePred>=t)==1)) / TeN;
%     end
%     
%     acc_th(1,counter) = sigma;                      % sigma value
%     
%     [acc_th(2,counter),thres] = max(TrAcc);         % max training accuracy
%     acc_th(3,counter) = thr(1,thres);         
%     
%     [acc_th(4,counter),thres] = max(TeAcc);         % max testing accuracy
%     acc_th(5,counter) = thr(1,thres);         
%     
%     counter = counter + 1;
%     %figure;
%     plot(thr,TrAcc,'.- ',thr,TeAcc,'^-');legend('tr','te','Location','southeast');
%     grid
%     title(strcat('Accuracy against Threshold (Width = ', " ", num2str(sigma), ")"))
%     ylabel("Accuracy"); xlabel("Threshold");
%     saveas(gcf,strcat("b_image/b_",num2str(sigma),".bmp"))
% end
% 
% figure;
% hold on
% plot(acc_th(1,:),acc_th(2,:),'-m');
% plot(acc_th(1,:),acc_th(4,:),'-k');
% legend('Training data','Test data','Location','northeast');
% grid
% title('Accuracy against Width');
% ylabel("Accuracy"); xlabel("Width");
% saveas(gcf,strcat("b_image/b_","acc against thres",".bmp"))
% 
% toc
% 
% function matrix = cal_i_mat(data, sigma, train_data)
% num_data = size(data,2);
% num_cen = size(train_data,2);
% matrix = zeros(num_data,num_cen);
% for i = 1:num_data
%     for j = 1:num_cen
%         disp(['For width = ' num2str(sigma) ', calculating (' num2str(i) ',' num2str(j),')'])
%         matrix(i,j) = exp (  (norm(data(:,i) - train_data(:,j)))^2  /  (-2*(sigma^2))   )  ;
%     end
% end
% end






%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 
% counter = 1;
% for i = 1:1000
%     train_RBF(i,1) = exp(      (norm(test_set_input(1,:) - training_set_input(:,i)))^2    /    (-2*(sigma^2))     );
%     disp(['now doing i = ' num2str(i)])
% end
% for reg = [0]
%     disp(reg)
%     
%     disp('w done')
%     fx = dot(w,e_RBF);
%     disp('fx done')
%     result = eval(subs(fx,x,test_set_input(1,:)));
%     disp('result done')
    % Plot test set simulation
%     figure
%     hold on
%     plot(training_set_input,training_set_output,'m-')
%     plot(test_set_input,test_set_output,'k-')
%     ttl = strcat('Graph of y against x (With regularization = '," ", sprintf('%.3f',reg),')');
%     xlabel('x'); ylabel('y'); title(ttl);
%     plot(test_set_input,result,'b-','Linewidth',1.4);
%     grid;
%     legend('Training set (with noise)', 'Test set (without noise)','Approximated function');
    % Find sum of squared error (performace)
%     mse(1,counter) = reg;
%     mse(2,counter) = mean(((result-test_set_output).^2),2);
%     training_result = eval(subs(fx,x,training_set_input(1,:)));
%     mse(3,counter) = mean(((training_result-training_set_output).^2),2);
%     counter = counter + 1;
% end
% toc












