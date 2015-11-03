function val = gui_getparm(parm, format, delimiter)
%----------------------------------------------------------
% Input Dialog Parameter
%
% parm      : Cell
% format    : '%s' : string, '%f' : number
% delimiter : ' ', ',', ';' ...
% val       : Value
%
% Author : Gwan-Taek Lee
% Last update : 2012. 02. 02
%----------------------------------------------------------

    val = textscan(parm, format, 'delimiter', delimiter);
    val = [val{:}];

end