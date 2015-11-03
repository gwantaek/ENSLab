function [P f] = lgt_powerspectrum(X, Fs, t_dim, e_dim, type)
%----------------------------------------------------------
% Power spectrum
%
% X      : Data matrix
% Fs     : Sampling rate
% t_dim  : Time dimension
% e_dim  : Epoch dimension (If it is [], no average)
% type   : 'abs' or 'rel' (absolute or relative)
% P      : Power
% f      : Discrete fourier transform
%
% Author : Gwan-Taek Lee
% Last update : 2011. 03. 02.
%----------------------------------------------------------
    [F f] = lgt_fft(X, Fs, t_dim);
    P = power(abs(F),2);
    
    % relative power = power / total power
    if(strcmp(type,'rel'))
        % sum을하면, 해당 축 사이즈가 1로 되기 때문에
        % sum을 하기 전 매트릭스와 ./ 연산을 하기 위해서는
        % size가 1이 된 축을 다시 원래 대로 돌려줄 필요가 있다.
        % 따라서 repmat 함수를 사용하기 위해
        % 원래 매트릭스의 size에서 다른 축들은 모두 1 이고
        % sum 되는 축만 처음의 사이즈를 유지시키는 과정이 필요
        P_size = size(P);
        rep_size = ones(1, length(P_size));
        rep_size(t_dim) = P_size(t_dim);
        tot_pow = repmat(sum(P, t_dim), rep_size);
        P = P ./ tot_pow;
    end
    
    % mean epoch
    if(~isempty(e_dim))
        P = squeeze(mean(P, e_dim));
    end
    
end