function [matrix, reward] = get_grids(r)
dim = 10;
reward = zeros(dim,dim);
matrix = cell(dim, dim);
state = 1;
for i = 1:dim
    for j = 1:dim
        reward_f = r(state,:);
        notvalid = find(logical(reward_f == -1));
        q_val = [0 0 0 0];                            
        if notvalid
            q_val(1,notvalid(1,:)) = -inf;
        end
        matrix{j,i} = q_val;
        state = state + 1 ;
    end
end
end

