function idx = lgt_freq2idx(freq, L, Fs, range)
%----------------------------------------------------------
% Find the index of the input-frequency 
% from the array of discrete frequency
%
% freq   : The frequency to find
% L      : Data length
% Fs     : Sampling rate
% range  : Low / high cut-off frequency
% idx    : The index of freq in the array of discrete frequency
%
% Author : Gwan-Taek Lee
% Last update : 2011. 08. 03.
%----------------------------------------------------------

    f = lgt_discretefreq(L, Fs, range);
    [tmp idx] = min(abs(f - freq));

end