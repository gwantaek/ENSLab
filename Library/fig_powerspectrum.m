function [P f] = fig_powerspectrum(X, Fs, range, t_dim, e_dim, type, deci)
%----------------------------------------------------------
% Figure power spectrum
% 이 함수는 time 혹은 time * epoch 인 1,2차 matrix만 사용 할 수 있음.
% 1차 matrix일 경우 e_dim에 [] 를 입력.
%
% X      : Data matrix
% Fs     : Sampling rate
% range  : Low / high cut-off frequency, default []
% t_dim  : Time dimension
% e_dim  : Epoch dimension (If it is [], no average)
% type   : 'abs' or 'rel' (absolute or relative)
% deci   : Decibel (1 or 0)
%
% Author : Gwan-Taek Lee
% Last update : 2011. 03. 02.
%----------------------------------------------------------

    [P f] = lgt_powerspectrum(X,Fs,t_dim,e_dim,type);
    if(~isempty(range))
        minf = lgt_find_index(range(1),f);
        maxf = lgt_find_index(range(2),f);
    else
        minf = 1;
        maxf = length(f);
    end
    
    P = P(minf:maxf);
    f = f(minf:maxf);
    
    if(deci==1)
        P = db(P);
    end
    
    plot(f, P);
    
    if(strcmp(type,'abs'))
        ylabel('Absolute Power');
    else
        ylabel('Relative Power');
    end
    
    title('Power Spectrum');
    xlabel('Frequency (Hz)');
    
end