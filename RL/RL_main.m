%% Initialise and Load variables
load qeval.mat

%% RL variables and Initialise Q-value and Index grids
% RL variables
rate_selection = 5;         % vary according to which rate decay type (1 to 5 only)
discount = 0.75;             % vary the discount rate
threshold = 0.005;          % threshold for learning rate to stop trial and q-function difference to stop run

max_trials = 3000;          % number of trials per run
number_of_runs = 1;        % number of runs to do to find average

% Specify reward matrix
reward_function = qevalreward;
grid_idx = reshape(1:1:100,[10 10]);
t = 0;

% Specify initial state and position
initial_state = 1;
[init_m, init_n] = find(initial_state == grid_idx);

% Specify final state and position
final_state = 100;
[final_m, final_n] = find(final_state == grid_idx);


%% Algorithm start
reached = 0;
avg_t = 0;
max_reward = 0;
for run = 1:number_of_runs
    disp(['Run number: ',num2str(run)]);
    tic
    [q_grid,reward_grid] = get_grids(reward_function);
    trial = 1;
    converge = false;
    while trial <= max_trials && ~converge
        %disp(['Run number: ', num2str(run), newline, 'Trial: ',num2str(trial),newline]);
        new_q_grid = q_grid;
        k = 0;
        state = initial_state; alpha = threshold + 1;
        
        % q-learning algorithm
        while state~=final_state && alpha > threshold
            [graph_title,k,alpha,state,q_grid] = q_learning_algor(rate_selection,k,state,grid_idx,q_grid,reward_function,discount);
        end
        
        % Trial termination condition check
        trial = trial + 1;
        converge = q_converge_check(new_q_grid, q_grid, threshold);
        
    end
    
    idx1 = init_m;
    idx2 = init_n;
    action_vec = {};
    qevalstates = [];
    move_vec = [];
    while grid_idx(idx1,idx2)~=final_state && reward_grid(idx1,idx2)==0
        [~, action_o] = max(q_grid{idx1,idx2});
        [reward_grid,move_vec,qevalstates,action_vec,idx1,idx2] = get_action_vec(reward_grid,action_o,idx1,idx2,action_vec,qevalstates,grid_idx,final_m,final_n,move_vec,reward_function);
    end
    
    r = sum(sum(reward_grid));
    
    if r > max_reward
        max_reward = r;
        max_vecs = {reward_grid,move_vec,qevalstates,action_vec};
    end
    % vecs = reward_grid / graph movement coordinates / optimal state / directions
    if max_vecs{1,3}(end,1) == final_state
        disp(['End state reached with optimal policy',newline])
        reached = reached + 1;
        t = t + toc;
        avg_t = t/reached;
        tot_avg_t = t/run;
    else
        t = t + toc;
        tot_avg_t = t/run;
        disp(['End state NOT reached with optimal policy',newline])
    end
    
end

axis ij;xlim([0,10]);ylim([0,10]);grid on;hold on;title({['\gamma = ', num2str(discount)];graph_title});
for i = 1:size(max_vecs{1,2},2)
    plot(max_vecs{1,2}(2,i),max_vecs{1,2}(1,i),max_vecs{1,4}{i,1},'MarkerSize',12);
end
xlabel(['Total reward = ', num2str(max_reward)])

disp(['Maximum reward is ' num2str(max_reward)]);
disp(['Average time is ', num2str(avg_t)])

disp(['Qevalstates obtained:',newline,num2str(qevalstates')])

