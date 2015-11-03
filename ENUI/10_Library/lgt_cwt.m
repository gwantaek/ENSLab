function C = lgt_cwt(X, Fs, f, cycle, type, shape)
%----------------------------------------------------------
% Complex Gabor/Morlet Wavelet
%
% X     : Data matrix (time X epoch)
% Fs    : Sampling rate
% f     ; Discrete frequency
% t_dim : Time dimension
% e_dim : epoch dimension
% cycle : the number of mother wavelet's cycles
% type  : 'gab' or 'mor'
% shape : 'same' or 'valid'
%           first one excepts the zero-phase edges
%           second does not it
% C     : Wavelet coefficients (freq X time X epoch)
% f     : Discrete frequency

% Author : Gwan-Taek Lee
% Last update : 2010. 11. 11
%               2010. 11. 26
%               2011. 04. 08 e_dim 추가
%----------------------------------------------------------
    n_time = size(X, 1);
    n_epch = size(X, 2);
    n_freq = length(f);
    
    % Freq X Time X Epoch
    C = nan(n_freq, n_time, n_epch);
    
    for e = 1 : n_epch
        
        Xe = X(:,e);
        
        for r = 1 : n_freq

            sig = 1/(2*pi*(f(r)/cycle));

            % window length = cycle / f
            t = (-(cycle/2)/f(r) : 1/Fs : (cycle/2)/f(r));

            % Mother wavelet
            if(strcmp(type,'gab'))
                G = exp(-t.^2/(2*sig^2)) .* exp(1i*2*pi*f(r)*t);
            elseif(strcmp(type,'mor'))
                G = ((sig*sqrt(pi))^-0.5) * exp(-t.^2/(2*sig^2)) .* exp(1i*2*pi*f(r)*t);
            end

            switch(shape)
                case 'same'
                    C(r,:,e) = conv(Xe, G, 'same');
                case 'valid'
                    % without the zero-padded edges
                    % 'valid' 옵션은 matlab 2010 버전 이후 지원
                    % 이전 버전에서는 kucnl_conv 사용
                    wlt = conv(Xe, G, 'valid');
                    n_wlt = length(wlt);

                    if(0 < n_wlt)
                        edge = floor((n_time - n_wlt) / 2);
                        C(r,edge+1:edge+n_wlt,e) = wlt;
                    end
            end % end of switch
        end % end of r
    end % end of e

end