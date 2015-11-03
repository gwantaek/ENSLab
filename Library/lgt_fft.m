function [F f] = lgt_fft(X, Fs, dim)
%----------------------------------------------------------
% Fast fourier transform with Hann window
%
% X      : Data matrix
% Fs     : Sampling rate
%
% F      : Fourier coefficients
% f      : Discrete fourier transform
%
% Author : Gwan-Taek Lee
% Last update : 2011. 03. 02.
%----------------------------------------------------------
    L = size(X,dim);
    nfft = lgt_nfft(L);
    
    f = Fs/2*linspace(0,1,nfft/2+1);    % create the frequency range
    F = fft(X, nfft, dim) / L * 2;    % padded with zero, then normalization
    
end