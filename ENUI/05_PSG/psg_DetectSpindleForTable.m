function [Head] = psg_DetectSpindleForTable(handles,channel,fband, alpha, ratio, dura)
%----------------------------------------------------------
% Detect Sleep Spindle
%
% Head
% Data
%
% Author : Gwan-Taek Lee
% Last update : 2011. 12. 20
%----------------------------------------------------------
global MarkedSpindle;


    for i = 1 : length(handles.i_file)
        disp(['Processing: ' handles.Head(handles.i_file(i)).FileName]);
        pause(0.0000000001);
        Head  = handles.Head(handles.i_file(i));
        name  = Head.FileName;
        path  = Head.FilePath;
        fs    = Head.SampRate;
        stime = Head.StartDate + Head.StartTime;
           
        chan  = util_GetIndex(Head.ChanLabel, channel);
        if (isempty(Head.Stage))
            msgbox('Please load staging data first');
            return
        end
        stage = util_GetIndex(Head.Stage.Label, 'N2');

        Data  = file_Load(name,path,'Data');
            
        Event = [];
        for c = 1 : length(chan)

            X = Data(chan(c),:);                                
               
            % By LCH
            X = my_filter(X,fband,fs);
                
            % Envelop
            X = abs(hilbert(X));
                
                % Detect
            candidate             = psg_SpindleCriteria1(Head, X, stage, alpha);
            [candidate candisamp duration] = psg_SpindleCriteria2(Head, X, candidate, ratio, dura);

            % Remove overlap
            s = 1;
            while s < length(candidate)
                if (candidate(s+1) - candidate(s)) < (dura/(1000/fs)*2)
                        % select bigger
                    if X(candidate(s)) >= X(candidate(s+1))
                        candidate(s+1) = [];
                        candisamp(s+1) = [];
                        duration(s+1) = [];
                    else
                        candidate(s) = [];
                        candisamp(s) = [];
                        duration(s) = [];
                    end
                else
                    s = s + 1;
                end
            end
                
            event.Label    = 'Auto';
            event.color    = 'r';
            event.Time     = util_GetOffTime(stime, fs, candidate);
            event.Channel  = channel;
%             event.Channel  = Head.ChanLabel(chan(c));
            event.Sample   = candisamp;
            event.duration = duration;
            Event          = [Event event];
                
                % marked spindle
            event.Label    = 'manual';                
            event.color    = 'b';
            sp_time = MarkedSpindle.Time;
                
            sp_time(sp_time > Head.StartTime) = sp_time(sp_time > Head.StartTime) + Head.StartDate;
            sp_time(sp_time < Head.StartTime) = sp_time(sp_time < Head.StartTime) + Head.StartDate + 1;
                
            event.Time     = sp_time;
            event.Channel  = Head.ChanLabel(chan(c));
            event.Sample   = [];
            dura = cell(1,length(event.Time));
            for kkk = 1:length(event.Time)
                dura{kkk} = util_GetOffIndex(stime,fs,event.Time(kkk));
            end
            event.duration = dura;
            Event          = [Event event];
        end
            
        Head.Event = Event;

    end
