function [candidate candisamp] = psg_SpindleCriteria3(candidate, candisamp, win, alpha)
%----------------------------------------------------------
% Correlation of candidate with a matching window
%
% candidate : Indexes of spindle obtained by Criteria1
% candisamp : Candidate Samples
% win       : Matching Window
% alpha     : Threshold
%
% candisamp : Candidate Sample
%
% Author : Gwan-Taek Lee
% Last update : 2011. 12. 20
%----------------------------------------------------------

    % 3rd criterion shape matching
    rej = [];
    for c = 1 : length(candidate)
        
        sample   = candisamp{c};
        n_sample = length(sample);
        m_window = window(win, n_sample);
        [R P]    = corrcoef(sample, m_window);
        
        if P(2) > alpha
            rej = [rej c];
        end
    end
    
    candidate(rej) = [];
    candisamp(rej) = [];
    candisamp = candisamp(~cellfun('isempty',candisamp));
    
end