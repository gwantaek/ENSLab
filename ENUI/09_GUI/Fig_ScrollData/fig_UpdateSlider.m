function fig_UpdateSlider(handles)
%----------------------------------------------------------
% Reset Slider
%
% handles
%
% Author : Gwan-Taek Lee
% Last update : 2012. 2. 6
%----------------------------------------------------------

    % Get data parameter
    fs     = handles.Head.SampRate;
    n_time = handles.Head.TimeNum;
    n_chan = length(handles.Head.DataChan);
    
    % Get GUI Parameter
    tdsp = ceil(get(handles.S_TimeDsp, 'value'));
    tpos = ceil(get(handles.S_TimeScr, 'value'));
    tick = ceil(get(handles.S_TickScr, 'value'));
    cdsp = ceil(get(handles.S_ChanDsp, 'Value'));
    cpos = ceil(get(handles.S_ChanScr, 'Value'));
    
    % Time Scroll Scaling
    tmax = n_time-(fs*tdsp)+1;
    if tpos > tmax
        set(handles.S_TimeScr, 'value', tmax);
    end        
    set(handles.S_TimeScr, 'Min', 1, 'Max', tmax);
    set(handles.S_TimeScr, 'SliderStep', [fs/(tmax-1) (fs/(tmax-1))*10]);

    % Tick Scroll Scaling
    if tdsp > 1
        if tick > tdsp
            set(handles.S_TickScr, 'Value', tdsp);
        end
        set(handles.S_TickScr, 'Enable', 'on');
        set(handles.S_TickScr, 'Min', 1, 'Max', tdsp);
        set(handles.S_TickScr, 'SliderStep', [1/(tdsp-1) 10/(tdsp-1)]);        
    else
        set(handles.S_TickScr, 'Value', 1);
        set(handles.S_TickScr, 'Enable', 'off');
    end
    
    % Channel Scroll Scaling
    cmax = n_chan-cdsp+1;
    if cdsp < n_chan
        if cpos > cmax
            set(handles.S_ChanScr, 'value', cmax);
        end                
        set(handles.S_ChanScr, 'Enable', 'on');
        set(handles.S_ChanScr, 'Min', 1, 'Max', cmax);
        set(handles.S_ChanScr, 'SliderStep', [1/(cmax-1) 10/(cmax-1)]);
    else
        set(handles.S_ChanScr, 'value', 1);
        set(handles.S_ChanScr, 'Enable', 'off');
    end
        
end