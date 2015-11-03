function fig_ResizeScrollData(width, height, handles)
%----------------------------------------------------------
% Resize Scroll Data Window
%
% width
% height
% handles
%
% Author : Gwan-Taek Lee
% Last update : 2012. 02. 07.
%----------------------------------------------------------

    % Margin
    Lb = 16;    % Label height
    Sc = 20;    % Scroll gap
    Mg = 10;    % Margin
    
    % Axis position
    T = (height-Lb);
    B = (Lb*2)+Sc+Mg;
    L = (Sc*3);
    R = (width-L-Mg);
    W = (R-L);
    H = (T-B);

    % Axes
    set(handles.A_Plot,         'Position', [L B W H]);
    
    % Time & Sens Scroll
    set(handles.S_TimeScr, 'Position', [L           (B-Mg-Sc) (W*0.9) Sc]);
    set(handles.S_SensDsp, 'Position', [(L+(W*0.9)) (B-Mg-Sc) (W*0.1) Sc]);
    
    % Time Scroll
    set(handles.S_TickScr, 'Position', [(R+Mg)    (B+Lb) Sc ((H/2)-Lb)]);
    set(handles.S_TimeDsp,  'Position', [(R+Sc+Mg) (B+Lb) Sc ((H/2)-Lb)]);    
    
    % Chan Scroll
    set(handles.S_ChanScr, 'Position', [(R+Mg)    (T-(H/2)) Sc ((H/2)-Lb)]);
    set(handles.S_ChanDsp, 'Position', [(R+Sc+Mg) (T-(H/2)) Sc ((H/2)-Lb)]);
        
    % Labels
    set(handles.L_StartTime, 'Position', [L               (B-Mg-Sc-Lb) ((W*0.9)/2) Lb]);
    set(handles.L_EndTime,   'Position', [(L+((W*0.9)/2)) (B-Mg-Sc-Lb) ((W*0.9)/2) Lb]);
    set(handles.L_SensDsp,   'Position', [(L+(W*0.9))     (B-Mg-Sc-Lb) (W*0.1)     Lb]);
    set(handles.L_TimeDsp,   'Position', [(R+Mg)          B            (Sc*2)      Lb]);    
    set(handles.L_Chan,      'Position', [(R+Mg)          (T-Lb)       (Sc*2)      Lb]);    

end