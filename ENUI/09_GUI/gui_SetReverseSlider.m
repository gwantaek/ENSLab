function gui_SetReverseSlider(h, rval)
%----------------------------------------------------------
% Set Reverse Value
%
% h       : handles
% val    : Reversed Value
%
% Author : Gwan-Taek Lee
% Last update : 2012. 2. 6
%----------------------------------------------------------

    smin = get(h,'min');
    smax = get(h,'max');
    val = (smin + smax) - rval;
    set(h, 'value', val);    
    
end