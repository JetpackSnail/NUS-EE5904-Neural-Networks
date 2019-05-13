% inputs: matrix = gram matrix to check for mercer's condition
%         thres = values below this threshold are considered to be zero
% outputs: (none) = indicates if the matrix satisfies mercer's condition
function mercer(matrix, thres)
e = eig(matrix);
logic_e = e < 0;
min_e = abs(min(e(e < 0)));

if (sum(logic_e) == 0) || (thres > min_e)
    disp('Passed Mercer condition');
else
    disp('Failed Mercer condition');

end
end