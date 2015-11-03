function [S f t P] = lgt_stft(X, Fs, r, p)
%----------------------------------------------------------
% STFT with Hann window
%
% X       : Data vector
% Fs      : Sampling rate
% r       : Length of window
% p       : Overlap percent (0 ~ 1)
%
% S       : Fourier coefficients 
% f       : Discrete fourier transform
% t       : Time segments
%
% Author : Gwan-Taek Lee
% Last update : 2012. 01. 31.
%----------------------------------------------------------
    L = length(X);
    n_over = ceil(r * p);
    window = hann(r);
    nfft = lgt_nfft(r);

    [S f t P] = spectrogram(X, window, n_over, nfft, Fs);
    
end