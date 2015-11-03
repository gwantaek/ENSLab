function idx = lgt_find_index(val, vector)
%----------------------------------------------------------
% Find the index of the closest value on input vector
%
% val    : value to find
% vector : value vector
% idx    : index on input vector
%
% Author : Gwan-Taek Lee
% Last update : 2011. 03. 02.
%----------------------------------------------------------
 
    [~,idx] = min(abs(vector - val));

end