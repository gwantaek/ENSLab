function srg = lgt_plv_srg(C, n_rand, n_samp)
%----------------------------------------------------------
% Surrogate PLV
%
% Channel X Time X Epoch
%
% C      : Complex number
% n_rand : The number of randomization
% n_samp : The number of sampling from epochs
%
% srg    : Pair X Time X Rand
%
% Author : Gwan-Taek Lee
% Last update : 2011. 09. 25
%----------------------------------------------------------

    n_chan = size(C, 1);
    n_time = size(C, 2);
    n_epch = size(C, 3);

    pair = nchoosek(1:n_chan,2);
    n_pair = length(pair);
    pair1 = pair(:,1);
    pair2 = pair(:,2);
    
    srg = zeros(n_pair, n_time, n_rand);
    phi = atan2(imag(C), real(C));
    
    for i = 1 : n_rand
        suff = randperm(n_epch);
        norm_ord = 1:n_samp;
        rand_ord = suff(1:n_samp);
        
        srg(:,:,i) = abs(mean(exp(1i * (phi(pair1,:,norm_ord)...
                                        - phi(pair2,:,rand_ord))), 3));
    end
    
end