function candidate = psg_SpindleCriteria1(Head, X, stage, alpha)
%----------------------------------------------------------
% Detect Sleep Spindle using Z-score threshold in a stage
%
% Head   : Data Head
% X      : Enveloped Data
% Stage  : Stage Index
% alpha  : Threshold
%
% Author : Gwan-Taek Lee
% Last update : 2011. 12. 20
%----------------------------------------------------------

    fs    = Head.SampRate;
    stime = Head.StartDate + Head.StartTime;    
    epch  = Head.Stage.Series(:,stage) == stage;
    time  = Head.Stage.Time(epch);
    sidx  = util_GetOffIndex(stime,fs,time);
    eidx  = sidx+(fs*Head.Stage.Duration)-1;
    
    peaks = GetPeak(X,1);
    prob  = cdf('norm', X(peaks), mean(X), std(X));
    candi = peaks(prob > (1-alpha));    % 이상하네 수정 요망 2015.08.04
 
    candidate = [];
    for t = 1 : length(time)
        idx       = bitand(sidx(t) <= candi, candi <= eidx(t));
        candidate = [candidate candi(idx)];
    end
    
end