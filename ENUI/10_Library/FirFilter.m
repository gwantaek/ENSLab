function [Y b] = FirFilter(X, fs, Wn, W, order)
%----------------------------------------------------------
% Windowed FIR filter (Zero-phase)
%
% X     : Input signal (Vector)
% fs    : Sampling rate
% Wn    : Pass / stop band
% W     : Window ('hann', 'hamming', ...)
% mul   : order = (fs / Wn(1)) * mul
% Y     : Filtered Signal
% b     : Filter
%
% Author : Gwan-Taek Lee
% Last update : 2011. 12. 20
%----------------------------------------------------------

    nqst = fs * (1/2);      % Nyquist frequency
    
    if isempty(order)
        order = 1000;
    end
    
    win = window(W, order+1);
    
    pass = Wn(1) / nqst;
    stop = Wn(2) / nqst;
    
    b = fir1(order, [pass stop], win);
    Y = filtfilt(b, 1, X);
    
end