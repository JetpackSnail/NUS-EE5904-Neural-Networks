function [graph_title, a_rate, e_rate]  = get_rates(selection, k)

switch selection
    case 1
        rate = 1 / k;
        graph_title = 'Rate = ^{1}/_{k}'; 
    case 2
        rate = 100 / (100 + k);
        graph_title = 'Rate = ^{100}/_{100 + k}'; 
    case 3
        rate = (1 + log(k)) / k;
        graph_title = 'Rate = ^{1 + log(k)}/_{k}'; 
    case 4
        rate = (1 + 5 * log(k)) / k;
        graph_title = 'Rate = ^{1 + 5log(k)}/_{k}'; 
    case 5
        rate = exp(-0.001*k);
        graph_title = 'Rate = e^{-0.001k}'; 
    otherwise
        error('invalid rate decay type');
end

if rate > 1 || rate == inf || rate == -inf
    rate = 1;
end

a_rate = rate;
e_rate = rate;

end