function nfft = freq_GetNfft(L)
%----------------------------------------------------------
% Get frequency bins & the length of FFT
%
% L      : The length of data
% nfft   : The length of FFT
%
% Author : Gwan-Taek Lee
% Last update : 2012. 02. 03.
%----------------------------------------------------------

    nfft = 2^(nextpow2(L));
    
end