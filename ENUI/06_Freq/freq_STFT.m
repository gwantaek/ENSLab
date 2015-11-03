function [S F T P] = freq_STFT(X, win, L, perc, Fs, F)
%----------------------------------------------------------
% Short-Time Fourier Transform
%
% X       : Data
% Fs      : Sampling rate
% F       : Frequency Bins
% win     : Window
% L       : Length of window
% perc    : Overlap Percentage (0 ~ 1)
%
% S       : Fourier coefficients 
% F       : Frequency Bins
% T       : Time segments
% P       : Power
%
% Author : Gwan-Taek Lee
% Last update : 2012. 01. 31.
%----------------------------------------------------------

    n_over = ceil(L * perc);
    win = window(win, L);

    if(isempty(F))
        % Faster than below method
        nfft = freq_GetFreqBins(L, Fs);
        [S,F,T,P] = spectrogram(X, win, n_over, nfft, Fs);
    else
        [S,F,T,P] = spectrogram(X, win, n_over, F, Fs);
    end
    
end