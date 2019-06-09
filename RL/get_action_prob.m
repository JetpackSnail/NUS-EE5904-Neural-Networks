function prob = get_action_prob(q_values,e)
prob(1,1:4) = inf;

[max_value, max_q_idx] = max(q_values);
max_value_idx = find(max_value == q_values);

if size(max_value_idx,2) == 1
    %disp('unique max q value')
else
    %disp('2 or more actions with same max q value')
    pos = randi(length(max_value_idx));
    max_q_idx = max_value_idx(1,pos);

end

invalid_idx = find(-inf == q_values);
prob(1, invalid_idx) = 0; %#ok<FNDSB>

prob(1,max_q_idx) = 1 - e;

etc_idx = find(inf == prob);
num_etc = size((etc_idx),2);
prob(1,etc_idx) = e / num_etc;
end