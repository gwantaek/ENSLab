function G = lgt_inverse_op(A, method)
%----------------------------------------------------------
% Inverse Operator G
%
% A      : Leadfield matrix
% method : 'LSM', 'SVD'
% G      : Inverse operator
%
% Author : Gwan-Taek Lee
% Last update : 2011. 08. 26
%----------------------------------------------------------

    switch method
        case 'LSM'
            % Least square method
            G = A.' / (A * A.');
            
        case 'SVD'
            % Singular value decomposition
            [U S V] = svd(A, 'econ');
            iS = inv(S);
            
            for r = 1 : size(iS, 1)
                if(iS(r,r) > 1.0e+10)
                    iS(r,r) = 0;
                end
            end
                    
            G = V * iS * U';
            
        case 'TNR'
        case 'WNE'
    end
end