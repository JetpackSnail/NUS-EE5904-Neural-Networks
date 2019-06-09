function [graph_title,k,alpha,new_state,q_grid] = q_learning_algor(rate_selection,k,state,grid_idx,q_grid,reward_function,discount)
% get learning rate and exploration probability
[graph_title, alpha, explore] = get_rates(rate_selection,k);
% select action
[m, n] = find(state == grid_idx);           % matrix index of current state
q_values = q_grid{m,n};                     % q values of each action of current state
prob = get_action_prob(q_values,explore);   % probability of doing each action at current state
action = randsample(4,1,true,prob);         % action to take
% apply action
new_state = get_newstate(action,state);
% receive reward
r = reward_function(state,action);
% observe next state
[a, b] = find(new_state == grid_idx);       % matrix index of next state
future_q = max(q_grid{a,b});
% update grids
q_values(1,action) = q_values(1,action) + alpha * (r + discount * future_q - q_values(1,action) );
q_grid{m,n} = q_values;
% prepare for next algorithm iteration
k = k + 1;
end

