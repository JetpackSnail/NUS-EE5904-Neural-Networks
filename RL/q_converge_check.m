function check = q_converge_check(grid1, grid2, t)
check = false;
temp = zeros(10,10);
for i = 1:10
    for j = 1:10
        temp(i,j) = max(abs(grid1{i,j} - grid2{i,j}));
    end
end

if max(max(temp)) < t
    disp('Converged')
    check = true;
end

end

