function f = lgt_discretefreq(L, Fs, range)
%----------------------------------------------------------
% Get discrete frequency
%
% L     : Data length
% Fs    : Sampling rate
% range  : Low / high cut-off frequency, default []
%
% f     : Discrete frequency

% Author : Gwan-Taek Lee
% Last update : 2011. 04. 08
%----------------------------------------------------------
    NFFT = 2^nextpow2(L);
    NQST = Fs * (2/5);  % Engineer's nyquist criterion
    
    f = Fs/2*linspace(0,1,NFFT/2+1);  % create the frequency range    
    f = f(1:lgt_find_index(NQST,f));  % 의미없는 부분은 잘라냄.
    
    % Frequency range
    if(~isempty(range))
        minf = lgt_find_index(range(1),f);
        maxf = lgt_find_index(range(2),f);
    else
        minf = 2;   % 0 제외
        maxf = length(f);
    end
    f = f(minf:maxf);
    
end