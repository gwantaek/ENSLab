function ERSP = lgt_ersp(F, dim)
%----------------------------------------------------------
% Inter trial coherence
%
% F     : Fourier coefficients
% dim   : Trial dimension
% ERSP
%
% Author : Gwan-Taek Lee
% Last update : 2011. 09. 05
%----------------------------------------------------------

    ERSP = squeeze(mean((abs(F).^2), dim));
    
end