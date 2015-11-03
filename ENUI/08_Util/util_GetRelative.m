function Y = util_GetRelative(X, dim)
%----------------------------------------------------------
%
% Author : Gwan-Taek Lee
% Last update : 2012. 03. 23.
%----------------------------------------------------------
    
    tot = sum(X, dim);
    
    if length(size(tot)) == length(size(X))
        repsize = size(X) ./ size(tot);
    else
        repsize = size(X) ./ [size(tot) 1];
    end
    
    tot = repmat(tot, repsize);
    Y = X./tot;
    
end