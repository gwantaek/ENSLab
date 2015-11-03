function rval = gui_GetReverseSlider(h)
%----------------------------------------------------------
% Return Reverse Value
%
% h       : handles
% rval    : Reverse Value
%
% Author : Gwan-Taek Lee
% Last update : 2012. 2. 6
%----------------------------------------------------------

    smin = get(h,'min');
    smax = get(h,'max');
    val = get(h, 'value');
    rval = (smin + smax) - val;
    
end