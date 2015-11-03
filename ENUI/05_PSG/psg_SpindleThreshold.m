function thr = psg_SpindleThreshold(Head, X, stage)
%----------------------------------------------------------
% Detect Sleep Spindle using Z-score threshold in a stage
%
% Head   : Data Head
% X      : Enveloped Data
% Stage  : Stage Index
%
% Author : Gwan-Taek Lee
% Last update : 2011. 12. 20
%----------------------------------------------------------

%     Fs       = Head.SampRate;
%     n_time   = Head.Stage.Duration * Fs;
%     n_epch   = length(Head.Stage.Time);
%     n_segm   = Head.Stage.Duration / 3;
%     n2epch   = Head.Stage.Series(:,stage) == stage;
%     n_n2epch = length(n2epch(n2epch==1));
%     
%     % Start ~ End Indexes (Stage Time)
%     stime   = Head.StartDate + Head.StartTime;
%     sidx    = util_GetOffIndex(stime,Fs,Head.Stage.Time(1));
%     eidx    = sidx+(n_time * n_epch)-1;
%     
%     % FFT, Calculate spectra
%     X = reshape(X(sidx:eidx), [n_time n_epch]);
%     X = X(:,n2epch);
%     
%     X = reshape(X, [Fs*3 n_n2epch*n_segm]);    
%     for e = 1 : n_n2epch*n_segm
%         X(:,e) = X(:,e) .* window(@hann, Fs*3);
%     end
%         
%     [P F] = lgt_powerspectrum(X, Fs, 1, 2, 'abs');
% 
%     XE = abs(hilbert(reshape(X, [1 Fs*3*n_n2epch*n_segm])));
%     peaks = GetPeak(XE,1);
%     
%     SP = max(sqrt(P));
%     NP = mean(XE(peaks));
%     SNR = SP / NP;
%     thr = SP * SNR;
    
    epch   = Head.Stage.Series(:,stage) == stage;
    P = psg_PowerSpectrum(Head,X,3,0.5);
    P = mean(P, 4);
    P = mean(P(:,:,epch),3);
    
    thr = max(P);
    
end