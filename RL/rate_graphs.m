hold on
grid on 
k = 0:1:500;
rate = 1 ./ k;
plot(k,rate,'r-')

rate = 100 ./ (100 + k);
plot(k,rate,'b-')

rate = (1 + log(k)) ./ k;
plot(k,rate,'r:')

rate = (1 + 5 * log(k)) ./ k;
rate(rate>1) = 1;
plot(k,rate,'b:')

rate = exp(-0.001*k);
rate(rate>1) = 1;
plot(k,rate,'m')

legend({'y = 1/k','y = 100/(100 + k)','y = (1 + log(k))/k','y = (1 + 5 * log(k))/k)', 'y = exp(-0.001*k)'},'Location','northeast')
title('Rate decay against Time step')
xlabel('Time step k'); ylabel('Rate decay');