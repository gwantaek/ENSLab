function Y = lgt_firfilter(X, fs, Wn, W)
%----------------------------------------------------------
% Windowed FIR filter
%
% X     : Input signal (Vector)
% fs    : Sampling rate
% Wn    : Pass / stop band
% W     : Window ('hann', 'hamming', ...)
%
% Author : Gwan-Taek Lee
% Last update : 2011. 12. 20
%----------------------------------------------------------

    L = length(X);
    nqst = fs / 2;
    N = floor(L / 3.1);  % N'th order
    if N > 500
        N = 500;
    end
    win = window(W, N+1);
        
    b = fir1(N, Wn/nqst, win);
    Y = filtfilt(b, 1, X);
end