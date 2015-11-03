function fig_UpdateAxes(handles)
%----------------------------------------------------------
% Redraw Axes
%
% handles
%
% Author : Gwan-Taek Lee
% Last update : 2012. 2. 6
%----------------------------------------------------------
global Head;

    handles.Head.Event = Head.Event;
    Head = handles.Head;
    % Get data parameter
    fs     = handles.Head.SampRate;
    n_time = handles.Head.TimeNum;
    stime  = handles.Head.StartDate + handles.Head.StartTime;
    n_chan = length(handles.Head.DataChan);    
    
    % Get GUI Parameter
    tdsp = ceil(get(handles.S_TimeDsp, 'value'));
    tpos = ceil(get(handles.S_TimeScr, 'value'));
    sens = ceil(get(handles.S_SensDsp, 'value'));
    tick = ceil(get(handles.S_TickScr, 'value'));
    cdsp = ceil(get(handles.S_ChanDsp, 'Value'));
    cpos = ceil(gui_GetReverseSlider(handles.S_ChanScr));
    filt = get(handles.C_Filter,'value');
    envel = get(handles.C_Envelope,'value');
    band = gui_GetParms(get(handles.E_Filter,'string'),'%f',',');
    
    % Time
    if (tpos+(tdsp*fs)-1) > n_time
        tpos = (n_time - (tdsp*fs)) + 1;    % End pade
    end    
    tidx = tpos:tpos+(tdsp*fs)-1;
    time = util_GetOffTime(stime, fs, tidx);
    
    % Tick
    tick = tick * fs;

    % Channel
    if (cpos+cdsp-1) > n_chan
        cpos = (n_chan - cdsp) + 1;         % End pade
    end
    cidx = cpos:cpos+cdsp-1;
    chan = handles.Head.ChanLabel(handles.Head.DataChan(cidx));

    % Event
    handles.Head.Event = Head.Event;
    if ~isempty(handles.Head.Event)
        Event   = handles.Head.Event;
        n_event = length(Event);
        event   = cell(1,n_event);
        for e = 1 : n_event
            eidx     = util_GetOffIndex(stime, fs, Event(e).Time);
            echan    = util_GetIndex(chan, Event(e).Channel);
            x        = eidx(bitand(eidx>=tidx(1),eidx<=tidx(end)))-tpos+1;
            [dur indices] = find(bitand(eidx>=tidx(1),eidx<=tidx(end))>0);
            y        = ones(size(x)) * echan * sens + (sens * 0.4);
            yy        = ones(size(x)) * echan * sens + (sens * 0.7);
            if(e == 2)
                y        = ones(size(x)) * echan * sens + (sens * 0.7);
                yy        = ones(size(x)) * echan * sens + (sens * 1);
            end
            str      = [Event(e).Label];
            dur = [];
            for k = 1:length(indices)
                dur = [dur num2cell(Event(e).duration{indices(k)} - tpos+1,[1 2])];
            end
            event{e} = {x,y,str,dur,yy, Event(e).color};
        end
    else
        event = [];
    end
    
    % Stage
    stage = [];
    if ~isempty(handles.Head.Stage)
        Stage   = handles.Head.Stage;
        sidx    = util_GetOffIndex(stime, fs, Stage.Time);
        [x1 n1] = max(sidx(sidx<=tidx(1))); % 스크롤 시작의 stage
        [x2 n2] = find(sidx(bitand(sidx>tidx(1), sidx<=tidx(end))));% 중간에서 변할경우
%         x       = [tpos x2]; % Stage Indexes 
%         n       = [n1 n2]; % Stage Number
%         
%         x       = x-tpos+1;
        if ~isempty(x1)
            x = 20;
            n = n1;
            y       = ones(size(x))*20;
            str     = Stage.Label(~isnan(Stage.Series(n,:)));
            stage   = {x,y,str};
        end
    end
    
    % Data Segmentation & Plot
    data = handles.Data(handles.Head.DataChan(cidx), tidx);

    if filt
        data = my_filter(data,band,fs);
%         for c = 1 : size(data,1)
%             data(c,:) = FirFilter(data(c,:),fs,band,'hann',100);              
%         end
    end    
    
    PlotScrollData(handles.A_Plot, data, sens, chan, time, tick, event, stage, envel);
        
end