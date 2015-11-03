function itc = lgt_itc(C, dim)
%----------------------------------------------------------
% Inter trial coherence
%
% C     : Complex number
% dim   : Dimension
% itc   : 
%
% Author : Gwan-Taek Lee
% Last update : 2010. 11. 26
%----------------------------------------------------------

    % 결과 같음
%     V = exp(1i * phi);
%     itc = abs(mean(V, dim));
%     itc = abs(mean(C ./ abs(C), dim));
itc = mean(C ./ abs(C), dim);
    
end