function fig_UpdateLabel(handles)
%----------------------------------------------------------
% Redraw Labels
%
% handles
%
% Author : Gwan-Taek Lee
% Last update : 2012. 2. 6
%----------------------------------------------------------

    tdsp = ceil(get(handles.S_TimeDsp, 'value'));
    sens = ceil(get(handles.S_SensDsp, 'value'));
%     tick = ceil(get(handles.S_TickScr, 'value'));
    
    % Labels
    set(handles.L_TimeDsp,   'String', [num2str(tdsp) ' sec']);
    set(handles.L_SensDsp,   'String', [num2str(sens) ' §Å']);
    
end