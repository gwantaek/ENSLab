function srrg = lgt_getsurrogate(X, n_rand)
%----------------------------------------------------------
% Get Surrogate data shuffling phase of X
%
% X      : Original signal
% n_rand : The number of shuffling
%
% srrg   : Surrogate data (X length * n_rand)
%
% Author : Gwan-Taek Lee
% Last update : 2011. 05. 25.
%----------------------------------------------------------

    coef = fft(X);
    n_time = length(X);
    srrg = zeros(n_time, n_rand);
    
    for r = 1 : n_rand
        r_pi = rand(1,n_time) * 2 * pi;         % generating random phase between 0~2pi
        r_phase = coef .* exp(1i * r_pi);
        srrg(:,r) = ifft(r_phase,'symmetric');
    end
    
end