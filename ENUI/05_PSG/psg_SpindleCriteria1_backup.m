function candidate = psg_SpindleCriteria1(Head, X, stage, alpha)
%----------------------------------------------------------
% Detect Sleep Spindle using Z-score threshold in a stage
%
% Head   : Data Head
% X      : Enveloped Data
% Stage  : Stage Index
% thr    : Threshold
%
% Author : Gwan-Taek Lee
% Last update : 2011. 12. 20
%----------------------------------------------------------

global SpindleArray;

% % =====141223 스테이지 nan 제거 ===============
% max_stage_length = length(Head.Stage.Series);
% for n = 1:max_stage_length % 그 행을 없애자. 전체 사이즈가 줄어듬
%     nn = max_stage_length - n +1;
%     if 0 == max(~isnan(Head.Stage.Series(nn,:)))
%         Head.Stage.Series(nn,:) = [] ; 
%     end
% end
% % ___________________________________________

    fs    = Head.SampRate;
    stime = Head.StartDate + Head.StartTime;
    epch  = Head.Stage.Series(:,stage) == stage;
    time  = Head.Stage.Time(epch);
    sidx  = util_GetOffIndex(stime,fs,time);
    eidx  = sidx+(fs*Head.Stage.Duration)-1;
    
    n_time = Head.Stage.Duration * fs;  
%     n_epch = length(epch);   % 이것도 이상해서 바꿔봄
    n_epch = sum(epch)
    
    idx1 = util_GetOffIndex(stime,fs,Head.Stage.Time(1)); %index (time point) of first stage
    idx2 = idx1 + (n_time*n_epch)-1;
    % 141218 X길이가 idx2보다 짧은 이유를 알아야함
    % n_time에 뭔가 문제가 있어보임
        
    X2 = reshape(X(idx1:idx2), [n_time n_epch]);     % 여기서 문제 발생 
    X2 = X2(:,epch);
    X2 = reshape(X2, [1 size(X2,1) * size(X2,2)]);

    X2P = GetPeak(X2,1);
    thr = prctile(X2(X2P), alpha);
    
    XP = GetPeak(X,1);
    candi = XP((X(XP) > thr));
 
    candidate = [];
    for t = 1 : length(time)
        idx       = bitand(sidx(t) <= candi, candi <= eidx(t));
        candidate = [candidate candi(idx)];
    end
    
end