function parms = gui_GetParms(parm, format, delimiter)
%----------------------------------------------------------
% Get Parameter from a Dialog
%
% parm      : Cell type
% format    : '%s', '%f', '%f %f'...
% delimiter : ' ', ',', ';' ...
% val       : Value
%
% Author : Gwan-Taek Lee
% Last update : 2012. 02. 02
%----------------------------------------------------------

    if ~isempty(parm)
        parms = textscan(parm, format, 'delimiter', delimiter);
        parms = [parms{:}];
    else
        parms = [];
    end

end