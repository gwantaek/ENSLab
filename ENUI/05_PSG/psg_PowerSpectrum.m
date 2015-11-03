function [P F] = psg_PowerSpectrum(Head,Data,win_sec,perc)
%----------------------------------------------------------
% Short-Time Fourier Transform
%
% win_sec : Window length (sec)
% perc    : Overlap Percentage (0 ~ 1)
%
% P       : Power Spectrum (Chan x Freq x Epch x Segm)
% F       : Frequency Bins
%
% Author : Gwan-Taek Lee
% Last update : 2012. 01. 31.
%----------------------------------------------------------



    % Data parameter
    Fs      = Head.SampRate;
    L       = win_sec * Fs;
    n_chan  = size(Data,1);
    n_time  = Head.Stage.Duration * Fs;
    n_epch  = length(Head.Stage.Time);
    n_segm  = (Head.Stage.Duration / win_sec) * 2 - 1;    
    F       = freq_GetFreqBins(L, Fs);
    n_freq  = length(F);
    nfft    = freq_GetNfft(L);
        
    % Start ~ End Indexes (Stage Time)
    stime   = Head.StartDate + Head.StartTime;
%     sidx    = util_GetOffIndex(stime, Fs, Head.Stage.Time(1));
%     150618 bugfix : 자꾸 34547841 라고 떠서 1로 강제 설정
    sidx    = 1 ;
%     150619 bug n_epch즉 Stage.Series의 길이가 실데이타보다 길어서 fix
    n_epch_min = fix(length(Data) / n_time) ; 
    n_epch = min([n_epch_min n_epch]) ;

    eidx    = sidx+(n_time * n_epch)-1;
    
    % FFT, Calculate spectra
    Data = reshape(Data(:,sidx:eidx), [n_chan n_time n_epch]);
    P = zeros([n_chan n_freq n_epch n_segm]);
    
    for c = 1 : n_chan
        for e = 1 : n_epch
            [~,~,~,P(c,:,e,:)] = freq_STFT(Data(c,:,e),'hann',L,perc,Fs,nfft);
        end
    end
    
end