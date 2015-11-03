function [candidate candisamp duration] = psg_SpindleCriteria2(Head, X, candidate, cut, dur)
%----------------------------------------------------------
% Detect Sleep Spindle using Z-score threshold in a stage
%
% Head      : Data Head
% X         : Enveloped Data
% candidate : Indexes of spindle obtained by Criteria1
% cut       : Cutting ratio from a peak (0~1)
%             If cut = 0.5 -> the half of a peak potential
% dur       : Minimum duration (ms)
%
% candisamp : Candidate Sample
%
% Author : Gwan-Taek Lee
% Last update : 2011. 12. 20
%----------------------------------------------------------

%     peak = X(candidate);

    rej = [];
    candisamp  = {};
    duration = {};
    
    % Left/Right search to find cut point away from a peak point
    for s = 1 : length(candidate)
        
        epoch = X(candidate(s):candidate(s)+Head.SampRate);
        peaks = GetPeak(epoch,1);
        [~,idx] = max(epoch(peaks));
        
        candidate(s) = candidate(s) + peaks(idx) - 1;
        
        
        l = 1;
        %while (X(candidate(s)-l) > (epoch(peaks(idx))*cut)) && (X(candidate(s)-l) > 0) % <= X(candidate(s)-l+1))
        while (X(candidate(s)-l) > 0) && (X(candidate(s)-l) <= X(candidate(s)-l+1))
            l = l + 1;
        end
        r = 1;
        %while (X(candidate(s)+r) > (epoch(peaks(idx))*cut)) && (X(candidate(s)+r) > 0) % <= X(candidate(s)+r-1))
        while (X(candidate(s)+r) > 0) && (X(candidate(s)+r) <= X(candidate(s)+r-1))
            r = r + 1;
        end

        range = candidate(s)-l:candidate(s)+r;
        candi      = X(candidate(s)-l:candidate(s)+r);
        n_candi    = length(candi);
        
        % 2nd criterion, candi < dur -> rejection
        if (n_candi*(1000/Head.SampRate)) < dur
            rej = [rej s];
        else
            candisamp = [candisamp, candi];
            duration = [duration, range];
        end
    end
    
    candidate(rej) = [];
    
end