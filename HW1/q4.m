%% question 4a
clc;
close all;
clear;
x = [1 0 ; 1 0.8 ; 1 1.6 ; 1 3 ; 1 4 ; 1 5];
d = [0.5 ; 1; 4; 5; 6; 8];
w= (inv(x'*x)*x'*d)';

m = w(1,2);
c = w(1,1);

a = 0:6; 
y = m * a + c;


points = [0 0.5 ; 0.8 1 ; 1.6 4 ; 3 5 ; 4 6 ; 5 8];
hold on
plot(a, y,'k')
plot(points(1:6,1), points(1:6,2),'x');
legend("LLS");
xlabel('x')
ylabel('y')
title("Implementation of Linear Least Squares")
grid;
%hold off

%% question 4b
clear;
clc;

x = [1 0 ; 1 0.8 ; 1 1.6 ; 1 3 ; 1 4 ; 1 5];
points = [0 0.5 ; 0.8 1 ; 1.6 4 ; 3 5 ; 4 6 ; 5 8];
d = points(:,2);
num_input = size(points, 1);
weights = [0.2 0.1];            % initialise random weights
weight_traj = weights;
rate = 0.5;

for n = 1:100
    total_error = 0;
    for i = 1 : 6
        error = d(i) - dot(weights,x(i,1:2));
        total_error = error^2 + total_error;
        weights = weights + rate*error*x(i,1:2); 
    end
    weight_traj(n+1,:) = weights;
    total_error_traj(n,:) = total_error;
end

hold on
plot(1:100,total_error_traj,'g');


xlabel('Iterations')
ylabel('Squared error')
title("Graph of Squared error against Number of iterations")
grid;

% plot(1:100, weight_traj(1:100,1), 'k');
% plot(1:100, weight_traj(1:100,2), 'm');
% legend("b", "w");
% xlabel('Number of Iterations')
% ylabel('Weight values')
% title("Graph of weight values against Number of iterations")
% grid;


%%
%% question 4a
clc;
close all;
clear;
x = [1 0 ; 1 0.8 ; 1 1.6 ; 1 3 ; 1 4 ; 1 5];
d = [0.5 ; 1; 4; 5; 6; 8];
w= (inv(x'*x)*x'*d)';

m = 1.4669;
c = 0.5591;

a = 0:6; 
y = m * a + c;


points = [0 0.5 ; 0.8 1 ; 1.6 4 ; 3 5 ; 4 6 ; 5 8];
hold on
plot(a, y,'m')
legend("LMS");
xlabel('x')
ylabel('y')
title("Implementation of Least Mean Squares")
grid;
hold off



