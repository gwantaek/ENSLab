function F = freq_GetFreqBins(L, Fs)
%----------------------------------------------------------
% Get frequency bins & the length of FFT
%
% L      : The length of data
% Fs     : Sampling rate
%
% F      : Frequency Bins
%
% Author : Gwan-Taek Lee
% Last update : 2012. 02. 03.
%----------------------------------------------------------

    nfft = freq_GetNfft(L);
    F = Fs/2*linspace(0,1,nfft/2+1);
    
end