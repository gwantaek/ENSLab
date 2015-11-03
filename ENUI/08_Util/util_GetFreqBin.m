function fbin = util_GetFreqBin(Fs, L)
%----------------------------------------------------------
%
% Author : Gwan-Taek Lee
% Last update : 2012. 03. 23.
%----------------------------------------------------------
    
    nfft = lgt_nfft(L);
    fbin = Fs/2*linspace(0,1,nfft/2+1);
    
end