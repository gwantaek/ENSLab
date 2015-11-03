function lat = lgt_tp2lat(timepoint, fs, baselength)
%----------------------------------------------------------
% Get latency from timepoint
%
% timepoint    : integer
% fs           : sampling rate
% baselength   : (ms)
% lat          : (ms)
%
% Author       : Gwan-Taek Lee
% Last update  : 2009. 10. 30
%----------------------------------------------------------


onepoint = 1000 / fs;
lat = (timepoint - (baselength / onepoint) - 1) * onepoint;
      
end % End of function