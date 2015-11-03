function [SGs thr] = lgt_bootstrap(X, N, P)
%----------------------------------------------------------
% Bootstrap method
%
% X     : Data (Time X Epoch)
% N     : N of randomization
% P     : P value
% t_dim : Time dimension
% e_dim : Epoch dimension
% SGs   : Surrogate data
% thr   : Significant threshold on the surrogate distribution
%
% Author : Gwan-Taek Lee
% Last update : 2011. 08. 09.
%----------------------------------------------------------

    X = permute(X, [t_dim])
    t_length = size(X, t_dim);
    e_length = size(X, e_dim);
    rand_latency = zeros(1, e_length);    
    SGs = zeros(1, N);
    
    parfor n = 1 : N
        for i = e : e_length
            rand_tmp = randperm(t_length);
            rand_latency(e) = rand_tmp(1);
        end
        
        SGs(n) = mean(X(
    end
    
    
end