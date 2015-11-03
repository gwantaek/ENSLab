function Xnorm = lgt_normalize_baseline(X, baseline, tdim)
%----------------------------------------------------------
% Normalization
% (X - mean of baseline) / std of baseline
%
% X     : Time course matrix
% tdim  : Time dimension
% Xnorm : Normalized X
%
% Author : Gwan-Taek Lee
% Last update : 2011. 03. 24.
%----------------------------------------------------------
    n_time = size(X,tdim);
    mat = ones(1,length(size(X)));
    mat(1) = n_time;
    
    sftX = shiftdim(X,tdim-1);
    sftAvg = repmat(mean(sftX(baseline,:,:,:,:,:,:,:),1), mat);
    sftStd = repmat(std(sftX(baseline,:,:,:,:,:,:,:),0,1), mat);
    clear sftX;
    
    base_avg = shiftdim(sftAvg,length(size(sftAvg))-(tdim-1));
    base_std = shiftdim(sftStd,length(size(sftStd))-(tdim-1));
    clear sftAvg sftStd;
    
    Xnorm = (X - base_avg) ./ base_std;
    
end