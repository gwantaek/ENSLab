function fig_coherence(X, Y, Fs, range, t_dim, e_dim)
%----------------------------------------------------------
% Figure Cross spectrum
% 이 함수는 time * epoch 인 2차 matrix만 사용 할 수 있음.
%
% X      : Data matrix
% Y      : Data matrix
% Fs     : Sampling rate
% range  : Low / high cut-off frequency, default []
% t_dim  : Time dimension
% e_dim  : Epoch dimension
%
% Author : Gwan-Taek Lee
% Last update : 2011. 03. 02.
%----------------------------------------------------------
    [R f] = lgt_coherence(X,Y,Fs,t_dim,e_dim);
    
    if(~isempty(range))
        minf = lgt_find_index(range(1),f);
        maxf = lgt_find_index(range(2),f);
    else
        minf = 1;
        maxf = length(f);
    end    
    
    plot(f(minf:maxf), R(minf:maxf));
    ylabel('Coherence');
    xlabel('Frequency (Hz)');
 
end