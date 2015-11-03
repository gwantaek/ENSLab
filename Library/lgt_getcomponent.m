function component = lgt_getcomponent(epoch, tw, p_or_n, type)
%% Take positive/negative peaks from signal
%
% INPUT :
%   epoch       - One epoch.
%   tw          - Time window containing your component.
%   p_or_n      - What component you need.
%               - Only '1' or '2' can be argument, 
%               - '1' is positive and '2' is negative component.
%   type        - This function provide two methods to take component.
%               - One is using Min/Max, the other is using getpeak func.
%   
%
% OUTPUT :
%   component   - It's not 'latency' but
%                    just 'time-point' of your component.
%                
%
% Author : Gwan-Taek Lee
%
% Date : 2009. 10. 14
%
%%


    %% Find not 'peak' but Min/Max Value in time window
    if(strcmp(type, 'minmax'))    
        
        if(p_or_n == 1)
            minmax = max(epoch(tw));
        elseif(p_or_n == 2)
            minmax = min(epoch(tw));
        else
            % invalid argument
        end
        
        for i = tw
            if(epoch(i) == minmax)
                component = i;
                break;
            end
        end

    %% Find Min/Max peak in time window
    elseif(strcmp(type, 'peak'))
        
        peaks = getpeaks(epoch(tw), p_or_n);
        
        % If there are one more peaks in specific time window,
        if(~isempty(peaks))
            peaks = peaks + tw(1) - 1;

            if(p_or_n == 1)
                minmax = max(epoch(peaks(:)));
            elseif(p_or_n == 2)
                minmax = min(epoch(peaks(:)));
            end
            
            for i = tw
                if(epoch(i) == minmax)
                    component = i;
                    break;
                end
            end
        
        % If there is no peak then return the most variable point of slope
        % taken by twice differentials        
        else
            diff1 = diff(epoch(tw));
            diff2 = diff(diff1);
            max_curve = max(abs(diff2));
            
            for i = 1 : length(diff2)
                if(abs(diff2(i)) == max_curve)
                    component = i + tw(1);
                    break;
                end
            end
        end
    end

    
end % End of function