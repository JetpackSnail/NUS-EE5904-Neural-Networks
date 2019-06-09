% Initialise
clc;
clear;
close all;

% Initialise teachers (inputs)
AND_teacher = [1 1 1 1; 0 0 1 1 ; 0 1 0 1 ; 0 0 0 1];
OR_teacher = [1 1 1 1 ; 0 0 1 1 ; 0 1 0 1 ; 0 1 1 1];
COMPLEMENT_teacher = [1 1 ; 0 1 ; 1 0];
NAND_teacher = [1 1 1 1 ; 0 0 1 1 ; 0 1 0 1 ; 1 1 1 0];
XOR_teacher = [1 1 1 1 ; 0 1 0 1 ; 0 0 1 1 ; 0 1 1 0];

teacher = COMPLEMENT_teacher;           % change this for each logic gate
rate = 0.5;                             % change this for learning rate

[dim, num_input] = size(teacher);
counter = 1;

weights = rand(1,dim-1);            


classified = false;

while not (classified)
    classified = true;
    for i = 1 : num_input
        y = dot(weights(counter,1:dim-1), teacher(1:dim-1 , i)) >= 0;
        error = teacher(dim,i) - y;
        if (not (error == 0))
            classified = false;
            weights(counter+1, 1:dim-1) = weights(counter, 1:dim-1) + (rate*error*teacher(1:dim-1 , i))';
            counter = counter + 1;
        end
    end
end

if dim-1 == 2
    figure;
    hold on;
    xlabel("Iterations");
    ylabel("Weight values");
    plot(weights(1:size(weights,1),1),'-ro');
    plot(weights(1:size(weights,1),2),'-mx');
    legend({'w0','w1'});
    grid on
    hold off
    
    figure;
    hold on;
    xlim([-0.5 1.5])
    ylim([-0.5 1.5])
    for i = 2
        if teacher(end,i) == 1
            plot(0,teacher(2,i),'bx');
        else
            plot(0,teacher(2,i),'ro');
        end
    end
    x = -10:100;
    m = -weights(end,2)/weights(end,3);
    c = -weights(end,1)/weights(end,3);
    y = m * x + c;
    plot(x, y,'k')
    grid on
    hold off
end

if dim-1 == 3
    figure;
    hold on;
    xlabel("Iterations");
    ylabel("Weight values");
    plot(weights(1:size(weights,1),1),'-ro');
    plot(weights(1:size(weights,1),2),'-mx');
    plot(weights(1:size(weights,1),3),'-b+');
    legend({'w0','w1','w2'});
    grid on
    hold off
    
    figure;
    hold on;
    xlim([-0.5 1.5])
    ylim([-0.5 1.5])
    for i = 1:num_input
        if teacher(end,i) == 1
            plot(teacher(2,i),teacher(3,i),'bx');
        else
            plot(teacher(2,i),teacher(3,i),'ro');
        end
    end
    x = -10:100;
    m = -weights(end,2)/weights(end,3);
    c = -weights(end,1)/weights(end,3);
    y = m * x + c;
    plot(x, y,'k')
    grid on
    hold off
end





