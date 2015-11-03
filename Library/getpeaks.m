function peaks = getpeaks(signal, p_or_n)
%% Take positive/negative peaks from signal
%
% INPUT :
%   signal     - One dimension matrix as signal
%   p_or_n      - What peak you need.
%               - Only '1' or '2' can be argument, 
%               - '1' is positive and '2' is negative component.
%
% OUTPUT :
%   peaks      - 2*n matrix containing peaks
%                The first row has positive peaks
%                The second row has negative peaks
%
% Author : Gwan-Taek Lee
%
% Date : 2009. 10. 08
%


%%
    signal_length = length(signal);
    
    n_peak = 1;
    peaks = zeros(0);

    if(signal(1) > signal(2))
        up = false;
    else
        up = true;
    end
    
    for i = 1 : signal_length-1
        if(up)
            if(signal(i) > signal(i+1))
                
                if(p_or_n == 1)
                    peaks(n_peak) = i;
                    n_peak = n_peak + 1;
                end
                
                up = false;
            end
        else
            if(signal(i+1) > signal(i))
                
                if(p_or_n == 2)
                    peaks(n_peak) = i;
                    n_peak = n_peak + 1;
                end
                
                up = true;
            end
        end
    end
      
end % End of function