%% Clear all
close all
clear
clc
tic

%% Initialise variables   
N = 2;                                  % dimnension of input vector
vert_M = 8;                             % vertical neurons
hor_M = 8;                              % horizontal neurons
M = vert_M * hor_M;                     % number of output neurons
iter = 1;                             % number of iterations
som_width = 5;                          % size of SOM (width)
som_height = 5;                         % size of SOM (height)
init_rate = 0.1;                        % initial rate
init_width = sqrt( (5^2 + 5^2)) / 2;    % initial width
init_w = rand(N,M);                     % initial weight
w = init_w;                             % initial weight
grid = getgrid(vert_M,hor_M);           % initialise grid

%% Training function
X = randn(800,2);
s2 = sum(X.^2,2);
trainX = (X.*repmat(1*(gammainc(s2/2,1).^(1/2))./sqrt(s2),1,2))';
figure
getplot(init_w,trainX,0)


%% Algorithm start
for n = 0:iter
    disp(strcat('Iteration: ', int2str(n))) 
    [rate, width] = getparam(init_rate, init_width,n,iter);
    for idx = 1:800
        sample = trainX(:,idx);     % get a sample vector
        [dis, winner,grid_col,grid_row] = getwinner(w,sample,M,vert_M,hor_M);    % get winning neuron
        h = getneighbourhood(vert_M,hor_M,grid_row,grid_col,width);         % find influence neighbourhood
        reshape_h = reshape(h',[1,64]);
        for i = 1:M
            w(:,i) = w(:,i) + rate * reshape_h(1,i) * (sample - w(:,i));    % calculate new weight
        end
    end

    getplot(w,trainX,n)
    
end

toc

%% Functions
function grid = getgrid(x, y)
num = 1;
for i=1:x
    for j=1:y
        grid(i,j) = num;
        num = num + 1;
    end
end
end

function [rate, width] = getparam(init_rate, init_width,n,iter)
    rate = init_rate * exp(-n/iter);
    T1 = iter/(log(init_width));
    width = init_width * exp(-n /T1);
end

function [dis, winner,grid_col,grid_row] = getwinner(w,sample,M,vert_M,hor_M)
for i = 1:M
    dis(1,i) = getnorm(w(:,i),sample);
end
winner = find(dis==min(dis));
grid_col = mod(winner,hor_M);
if grid_col == 0
    grid_col = 8;
end
grid_row = ceil(winner/vert_M);
end

function h = getneighbourhood(vert_M,hor_M,grid_row,grid_col,width)
for i = 1:vert_M
    for j = 1:hor_M
        d(i,j) = -1 * (getnorm( [i j] , [grid_row grid_col] ) )^2;
        h(i,j) = exp(d(i,j) / (2*width^2));
    end
end
end

function dist = getnorm(a,b)
dist = norm(a-b);
end

function getplot(w,trainX,n)
reshape_w = reshape(w',[8 8 2]);
    plot(reshape_w(:,:,1), reshape_w(:,:,2),'k*')
    hold on
    plot(trainX(1,:),trainX(2,:),'+r');
    for A = 1:8
        plot(reshape_w(:,A,1),reshape_w(:,A,2),'k-')
        plot(reshape_w(A,:,1),reshape_w(A,:,2),'k-')
    end
    xlabel('x'); ylabel('y')
    title(sprintf('Graph of Y against X (Iteration %d)',n))
    hold off  
    drawnow;
end
