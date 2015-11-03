function plv = lgt_plv(C, dim)
%----------------------------------------------------------
% Phase Locking Value
%
% Chanels must be the first column.
%
% C     : Complex number
% dim   : Epoch Dimension
% plv   : Phase locking value
%
% Author : Gwan-Taek Lee
% Last update : 2011. 09. 25
%----------------------------------------------------------

    n_chan = size(C, 1);
    pair = nchoosek(1:n_chan,2);
    
    phi = atan2(imag(C), real(C));
    plv = abs(mean(exp(1i * (phi(pair(:,1),:,:,:,:,:,:) - phi(pair(:,2),:,:,:,:,:,:))), dim));
    
end