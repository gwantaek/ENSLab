function fig_Move2Event(handles, way)
%----------------------------------------------------------
% Move pre/next event
%
% handles
%
% Author : Gwan-Taek Lee
% Last update : 2012. 2. 6
%----------------------------------------------------------

    Head = handles.Head;
    
    % Get data parameter
    fs      = Head.SampRate;
    stime   = Head.StartDate + Head.StartTime;
    
    % Get GUI Parameter
    tdsp = ceil(get(handles.S_TimeDsp, 'value'));    
    tpos = ceil(get(handles.S_TimeScr, 'value'));
    
    ctime   = util_GetOffTime(stime,fs,tpos+(tdsp*fs/2));
    e       = get(handles.P_EventList, 'Value');
    n_event = length(Head.Event(e).Time);
    
    eidx = util_GetIndex(Head.Event(e).Time, ctime);
    etime = Head.Event(e).Time(eidx);
    epos = util_GetOffIndex(stime,fs,etime) - (tdsp*fs/2);              
    
    if tpos == epos
        
        eidx = eidx + way;
        if eidx < 1
            eidx = 1;
        elseif eidx > n_event
            eidx = n_event;
        end
        
        etime = Head.Event(e).Time(eidx);
        epos = util_GetOffIndex(stime,fs,etime) - (tdsp * fs / 2);
        
    end
    
    set(handles.S_TimeScr, 'value', epos);

end