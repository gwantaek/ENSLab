function [handles ok] = psg_DetectSpindle(handles)
%----------------------------------------------------------
% Detect Sleep Spindle
%
% Head
% Data
%
% Author : Gwan-Taek Lee
% Last update : 2011. 12. 20
%----------------------------------------------------------

global detectionParam;
global Head;
global MarkedSpindle;
global AutoSpindle;
global SpindleArray;

if (handles.n_file > 0) && strcmpi(handles.mode, 'file')
    Head = handles.Head;
    for i=1:length(Head.ChanLabel)
        ChanLab = Head.ChanLabel{i};
        if ( strcmpi(ChanLab(1:2), 'C3') )
            break;
        end
    end
    parms = inputdlg({'Select Channels',...
                      'Sleep Stage',...
                      'Frequency Range (Hz) - Min Max',...
                      'Potential PDF alpha',...
                      'Energy Ratio (0~1)',...
                      'Min Spindle Duration (ms)',...
                      'Label',...
                      'Overwrite? (Y / N)'},'',1,...
                     {ChanLab,'N2','10 16','99','0.5','400','Auto','Y'});
    
    if ~isempty(parms)

        ChanLab  = upper(gui_GetParms(parms{1}, '%s', ' '));
        StageLab = upper(gui_GetParms(parms{2}, '%s', ' '));
        fband    = gui_GetParms(parms{3}, '%f %f', ' ');
        palpha   = gui_GetParms(parms{4}, '%f', ' ');
        ratio    = gui_GetParms(parms{5}, '%f', ' ');
        mindur   = gui_GetParms(parms{6}, '%f', ' ');
        EventLab = gui_GetParms(parms{7}, '%s', ' ');
        bOverWrt = gui_GetParms(parms{8}, '%s', ' ');
        detectionParam.ChanLab = ChanLab;
        detectionParam.StageLab = StageLab;
        detectionParam.fband = fband;
        detectionParam.palpha = palpha;
        detectionParam.ratio = ratio;
        detectionParam.mindur = mindur;
        detectionParam.EventLab = EventLab;
        detectionParam.bOverWrt = bOverWrt;
        
        for i = 1 : length(handles.i_file)
            disp(['Processing: ' handles.Head(handles.i_file(i)).FileName]);
            pause(0.0000000001);
            Head  = handles.Head(handles.i_file(i));
            name  = Head.FileName;
            path  = Head.FilePath;
            fs    = Head.SampRate;
            stime = Head.StartDate + Head.StartTime;
           
            chan  = util_GetIndex(Head.ChanLabel, ChanLab);
            if (isempty(Head.Stage))
                msgbox('Please load staging data first');
                return
            end
            stage = util_GetIndex(Head.Stage.Label, StageLab);

%             namelength = length(name);
%             if (namelength > 5) && strcmp(name(end-3:end),'head')
%                 name = name(end-4:end);
%                 Head.Filename = name;
%                 handles.Head.Filename = name;
%             end
            Data  = file_Load(name,path,'Data');
            
            Event = [];
            for c = 1 : length(chan)

                X = Data(chan(c),:);                                
               
                % By LCH
                X = my_filter(X,fband,fs);
                
                % Envelop
                X = abs(hilbert(X));
                
                % Detect
                candidate             = psg_SpindleCriteria1(Head, X, stage, palpha);
                [candidate candisamp duration] = psg_SpindleCriteria2(Head, X, candidate, ratio, mindur);
%                 [candidate candisamp] = psg_SpindleCriteria3(candidate,candisamp,'hann',0.05);
                
                % Remove overlap
                s = 1;
                while s < length(candidate)

                    if (candidate(s+1) - candidate(s)) < (mindur/(1000/fs)*2)
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
                
                event.Label    = EventLab{1};
                event.color    = 'r';
                event.Time     = util_GetOffTime(stime, fs, candidate);
                event.Channel  = Head.ChanLabel(chan(c));
                event.Sample   = candisamp;
                event.duration = duration;
                Event          = [Event event];
                
                % marked spindle
                event.Label    = MarkedSpindle.Label;                
                event.color    = 'b';
                sp_time = MarkedSpindle.Time;
                
%                 sp_time(sp_time > Head.StartTime) = sp_time(sp_time >
%                 Head.StartTime) + Head.StartDate;
                sp_time(sp_time >= Head.StartTime) = sp_time(sp_time >= Head.StartTime) + Head.StartDate;
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
            
            if strcmp(bOverWrt, 'Y')
                Head.Event = Event;
            else
                Head.Event = [Head.Event Event];
            end
%            assignin('base','Head', Head);
            save('Head.mat','Head','-v7.3');
            file_Save(Head,[],[],[]);
            handles.Head(handles.i_file(i)) = Head;
        end
        
        ok = 1;
        disp('Detection Done');

        
    else
        ok = 0;
    end
    
else    
    msgbox('Select Files!!!','Error','error');
    ok = 0;   
end
