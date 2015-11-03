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
        % sum���ϸ�, �ش� �� ����� 1�� �Ǳ� ������
        % sum�� �ϱ� �� ��Ʈ������ ./ ������ �ϱ� ���ؼ���
        % size�� 1�� �� ���� �ٽ� ���� ��� ������ �ʿ䰡 �ִ�.
        % ���� repmat �Լ��� ����ϱ� ����
        % ���� ��Ʈ������ size���� �ٸ� ����� ��� 1 �̰�
        % sum �Ǵ� �ุ ó���� ����� ������Ű�� ������ �ʿ�
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