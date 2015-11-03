function otime = util_GetOffTime(stime, fs, idx)
%----------------------------------------------------------
% Return Offset Time from Start Time
%
% stime     : Start time
% fs        : Sampling Rate
% idx       : Offset from stime
% otime      : Offset Time
%
% Author : Gwan-Taek Lee
% Last update : 2012. 02. 07.
%----------------------------------------------------------

    itv = (datenum([2010 01 01 00 00 01])-datenum([2010 01 01 00 00 00])) / fs;    
    otime = (stime+(itv*(idx-1)));

end