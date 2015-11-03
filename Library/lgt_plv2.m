function plv = lgt_plv2(C, cdim, edim)
%----------------------------------------------------------
% Phase Locking Value
%
% C     : Complex phase matrix
% cdim  : Channel dimension
% edim  : Epoch dimension
%
% Author : Gwan-Taek Lee
% Last update : 2011. 03. 24.
%----------------------------------------------------------
    phi = atan2(imag(C), real(C));
    
    n_chan = size(phi, cdim);
    pair = nchoosek(1:n_chan,2);
    
    sftPhi = shiftdim(phi,cdim-1);
    sftDiff = sftPhi(pair(:,1),:,:,:,:,:,:,:) -...
            sftPhi(pair(:,2),:,:,:,:,:,:,:);
    diff = shiftdim(sftDiff,length(size(sftDiff))-(cdim-1));
    
    V = exp(1i * diff);
    plv = abs(mean(V, edim));
    
end