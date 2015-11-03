function [R f] = lgt_coherence(X, Y, Fs, t_dim, e_dim)
%----------------------------------------------------------
% Cross spectrum
%
% X      : Data matrix
% Y      : Data matrix
% Fs     : Sampling rate
% t_dim  : Time dimension
% e_dim  : Epoch dimension
% R      : Coherence
% f      : Discrete fourier transform
%
% Author : Gwan-Taek Lee
% Last update : 2011. 03. 02.
%----------------------------------------------------------
    [Fx f] = lgt_fft(X,Fs,t_dim);
    [Fy f] = lgt_fft(Y,Fs,t_dim);
    [Px f] = lgt_powerspectrum(X,Fs,t_dim,e_dim,'abs');
    [Py f] = lgt_powerspectrum(Y,Fs,t_dim,e_dim,'abs');
    
    Cxy = mean(Fx.*conj(Fy),e_dim);
    R = power(abs(Cxy),2) ./ (Px.*Py);
 
end