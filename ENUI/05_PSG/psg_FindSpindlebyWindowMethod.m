function candidate = psg_FindSpindlebyWindowMethod(Head, X)
%----------------------------------------------------------
% Detect Sleep Spindle using Windowing Powerspectrum
%
% Head   : Data Head
% X      : Enveloped Data
%
% Author : Gwan-Taek Lee
% Last update : 2015. 08. 03
%----------------------------------------------------------

%    fs    = Head.SampRate;
%    stime = Head.StartDate + Head.StartTime;    
%    epch  = Head.Stage.Series(:,stage) == stage;
%    time  = Head.Stage.Time(epch);
%    sidx  = util_GetOffIndex(stime,fs,time);
%    eidx  = sidx+(fs*Head.Stage.Duration)-1;
    
%    peaks = GetPeak(X,1);
%    prob  = cdf('norm', X(peaks), mean(X), std(X));
%    candi = peaks(prob > (1-alpha));
 
%    candidate = [];
%    for t = 1 : length(time)
%        idx       = bitand(sidx(t) <= candi, candi <= eidx(t));
%        candidate = [candidate candi(idx)];
%    end
 
    Fs = Head.SampRate;

    stage = util_GetIndex(Head.Stage.Label, 'N2');
    stime = Head.StartDate + Head.StartTime;    
    epch  = Head.Stage.Series(:,stage) == stage;
    time  = Head.Stage.Time(epch);
    sidx  = util_GetOffIndex(stime,Fs,time);
    eidx  = sidx+(Fs*Head.Stage.Duration)-1;
    
%    peaks = GetPeak(X,1);
%    prob  = cdf('norm', X(peaks), mean(X), std(X));
%    candi = peaks(prob > (1-alpha));    % 이상하네 수정 요망 2015.08.04
 


    candidate = [];
    
    ts = 20/(1000/Fs);
    w = 1;
    while (w < length(X)-Fs)
   % for w = 1 : ts : length(X)-Fs
        
        peak = 0;
        
        for t = 1 : length(time)
            if (sidx(t) <= w) && (w <= eidx(t))
               
                epoch = X(w:w+Fs-1);

                % Get Powerspectrum of Spindles
                [P, f] = lgt_powerspectrum(epoch,Fs,2,[],'abs');
                max_hz = 30;
                idx = lgt_find_index(max_hz, f);
                % Get Relative Power
                P = P(1:idx) ./ sum(P(1:idx));

                % 10~16 Hz Peak Value average & sd
                low_sp = lgt_find_index(10, f);
                hig_sp = lgt_find_index(16, f);

                peak = max(P(:,low_sp:hig_sp));
   
                if peak >= 0.2
                    candidate = [candidate w];
                    w = w + Fs;
                    break;
                end
                
            end
        end
        
        w = w + ts;
        
            
    end


end