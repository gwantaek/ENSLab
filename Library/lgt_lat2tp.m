function tp = lgt_lat2tp(latency, fs, baselength)
%----------------------------------------------------------
% Get timepoint from latency and baseline
%
% latency      : (ms)
% fs           : sampling rate
% baselength   : (ms)
% tp           : timepoint
%
% Author       : Gwan-Taek Lee
% Last update  : 2009. 10. 30
%----------------------------------------------------------


onepoint = 1000 / fs;
tp = ((latency + onepoint) / onepoint) + (baselength / onepoint);
      
end % End of function