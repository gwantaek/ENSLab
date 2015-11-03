function X = WindowX(X, win)
%----------------------------------------------------------
% Detect Sleep Spindle using Z-score threshold in a stage
%
% X      : Data (Time X Epoch)
% win    : Window Function (
% stage  : Sleep Stage
%
% Author : Gwan-Taek Lee
% Last update : 2012. 6. 8
%----------------------------------------------------------

    n_time = size(X, 1);
    n_epch = size(X, 2);
    wf = window(win, n_time);
    
    for e = 1 : n_epch
        X(:,e) = X(:,e) .* wf;
    end