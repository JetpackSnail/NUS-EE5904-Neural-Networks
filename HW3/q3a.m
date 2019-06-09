%% Initialise
close all
clear
clc
tic

N = 2;          % dimnension of input vector
M = 40;         % number of output neurons
iter = 500;     % number of iterations

init_rate = 0.1;
init_width = sqrt( (1^2 + 25^2)) / 2 ;

w = -3 + 6 .*rand(N,M);
weight = w;
x = linspace(-pi,pi,400);
trainX = [x;sinc(x)];

%% Algorithm start
for n = 0:iter
    if ~logical(mod(n,100))
        figure
        plot(trainX(1,:),trainX(2,:),'+r'); axis equal
        hold on
        plot(weight(1,:),weight(2,:),'-o')
        plot(w(1,:),w(2,:),'m-o')
        title(sprintf('Graph of Y against X (Iteration %d)',n))
        xlabel('x'); ylabel('y')
        legend('y = sinc(x)','Random','SOM');
        grid;
    end
    disp(n)
    for idx = 1:400
        % choose sample vector
        sample = trainX(:,idx);
        
        % calculate rate
        rate = init_rate * exp(-n/iter);
        % calculate width
        T1 = iter/(log(init_width));
        width = init_width * exp(-n /T1);

        % determine winning neuron and neighbourhood h and new weight
        for i = 1:M
            dis(1,i) = norm(w(:,i)-sample);
        end
        
        winner = find(dis==min(dis));
        
        for i = 1:M
            d = -1 * (i-winner)^2;
            h(1,i) = exp(d / (2*width^2));
            w(:,i) = w(:,i) + rate * h(1,i) * (sample - w(:,i));
        end
    end
end

