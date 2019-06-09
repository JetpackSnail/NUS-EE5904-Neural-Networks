function [reward_grid,move_vec,qstates_vec,action_vec,new_idx1,new_idx2] = get_action_vec(reward_grid,action_o,idx1,idx2,action_vec,qstates_vec,grid_idx,final_m,final_n,move_vec,reward_function)
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
reward_grid(idx1,idx2) = reward_function(grid_idx(idx1,idx2),action_o);
action_vec = cat(1,action_vec,strcat(action,'b'));
qstates_vec = cat(1,qstates_vec,grid_idx(idx1,idx2));
move_vec = cat(2,move_vec,[idx1-0.5;idx2-0.5]);

if new_idx1==final_m && new_idx2==final_n
    qstates_vec = cat(1,qstates_vec,grid_idx(final_m,final_n));
    action_vec = cat(1,action_vec,'rp');
    move_vec = cat(2,move_vec,[final_m-0.5;final_n-0.5]);
end


end

