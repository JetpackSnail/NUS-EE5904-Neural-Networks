function [new_idx1, new_idx2, new_q_counter, qstates] = get_plot(action_o,idx1,idx2,qcounter,qstates)

switch action_o
    case 1
        action = '^';
        new_idx1 = idx1 - 1;
        new_idx2 = idx2;
    case 2
        action = '>';
        new_idx2 = idx2 + 1;
        new_idx1 = idx1;
    case 3
        action = 'v';
        new_idx1 = idx1 + 1;
        new_idx2 = idx2;
    case 4
        action = '<';
        new_idx2 = idx2 - 1;
        new_idx1 = idx1;
end



%plot(idx2-0.5,idx1-0.5, strcat(action,'b') ,'MarkerSize',12)
new_q_counter = qcounter + 1;

% if new_idx1==final_m && new_idx2==final_n
%     qstates(qcounter,1) = final_state;
%     plot(new_idx2-0.5,new_idx1-0.5,'rp','MarkerSize',12)
% end

end

