function [PF Pow] = psg_GetPeakFrequency(Head, X, fband, stage)
%----------------------------------------------------------
% Detect Sleep Spindle using Z-score threshold in a stage
%
% Head   : Data Head
% X      : Data
% fband  : Frequency Range (Broad Band)
% stage  : Sleep Stage
%
% Author : Gwan-Taek Lee
% Last update : 2012. 6. 8
%----------------------------------------------------------

    fs     = Head.SampRate;
    tseg   = Head.Stage.Duration * fs;
    stime  = Head.StartDate + Head.StartTime;    
    epch   = Head.Stage.Series(:,stage) == stage;
    n_epch = length(epch);
    time   = Head.Stage.Time;
    sidx   = util_GetOffIndex(stime,fs,time(1));
    eidx   = sidx+(tseg*n_epch)-1;

%     X = FirFilter(X, fs, fband, 'hann', 200);
    X = my_filter(X, fband, fs);
    X = reshape(X(sidx:eidx), [tseg n_epch]);
    X = X(:,epch);    
    X = WindowX(X, 'hann');
    
    [P F] = lgt_powerspectrum(X, fs, 1, 2, 'abs');
    [Y I] = max(P);
    PF = F(I);
    Pow = Y;
    
end