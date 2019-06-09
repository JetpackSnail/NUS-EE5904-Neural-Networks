clc;
clear;
close all;
tic;

syms x y
f = (1-x)^2 + 100*(y-x^2)^2;
g = [diff(f,x);diff(f,y)];
i = 1;
f1 = [inf];


rate = 0.001;                       % change this for learning rate
weights = [-0.5 ; 0.5];             % change this for initial weights
threshold = 0.00005;                % change this for threshold for stopping condition



while (f1(1,:)) > threshold 
    weights(:,i+1) = weights(:,i) - rate * subs(g,{x;y},{weights(:,i)});
    f1(:,i) = subs(f,{x,y},{weights(1,i),weights(2,i)});
    i = i + 1;
end
toc;



plot(1:size(weights, 2),weights(1,:));
hold on ;
plot(1:size(weights, 2),weights(2,:));



plot(f1)
xlabel('Number of Iterations')
ylabel('Function Value')
title('Graph of Function value against Iterations')
grid



plot(weights(1,:), weights(2,:)) 
xlabel('x')
ylabel('y')
title('Trajectory of weights')
grid
