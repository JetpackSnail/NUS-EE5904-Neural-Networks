% inputs: data = unpreprocessed data matrix (Features x N)
% outputs: matrix = standardised data
function matrix = strd(data)           
N = size(data,2);
m = mean(data,2);
s = std(data,0,2); 
new_d = data - repmat(m,1,N);
matrix = new_d./s;
end