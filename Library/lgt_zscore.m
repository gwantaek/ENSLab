function Z = lgt_zscore(X, P, dim)
%----------------------------------------------------------
% Z score
% (X - mean of P) / std of P
%
% X     : Data
% P     : Population
% dim   : dimension
% Z     : Z score
%
% Author : Gwan-Taek Lee
% Last update : 2011. 08. 03.
%----------------------------------------------------------
    
    if(length(size(X)) == dim)
        X = permute(X, dim:-1:1);
        P = permute(P, dim:-1:1);
        M = mean(P, 1);
        S = std(P, 0, 1);

        xs = size(X);
        ms = size(M);    
        matdim = ((ms ~= xs) .* xs) + ~((ms ~= xs) .* xs);

        Z = (X - repmat(M, matdim)) ./ repmat(S, matdim);
        Z = permute(Z, dim:-1:1);
    else
        M = mean(P, dim);
        S = std(P, 0, dim);

        xs = size(X);
        ms = size(M);    
        matdim = ((ms ~= xs) .* xs) + ~((ms ~= xs) .* xs);

        Z = (X - repmat(M, matdim)) ./ repmat(S, matdim);        
    end
    
end