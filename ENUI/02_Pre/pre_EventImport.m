function [handles ok] = pre_EventImport(handles)
%----------------------------------------------------------
% Import Sleep Stage Log Files
%
% Head       : Header
% selitem    : Selected File
% parms      : GUI Input Parameter
% logpath    : Log Files path 
%                - must same gtb and log filename
%                - aaa.gtb & aaa.xls
% logext     : Log Extension
%
% Author : Gwan-Taek Lee
% Last update : 2012. 02. 05.
%----------------------------------------------------------

if (handles.n_file == 1) && strcmpi(handles.mode, 'file')

    [file path] = uigetfile({'*.xlsx', 'Excel File (*.xlsx)'});
    parms = inputdlg({'Event Label',...
                        'Channel'},'',1,...
                        {'↑M-Spindle','C4'});
                       
    if ~isempty(file) && ~isempty(parms)
        selitem = handles.i_file;
        
        logfile = [path file];
        EventLabel = parms{1};
        ChanLabel = gui_GetParms(parms{2}, '%s', ' ');
        
        Head = handles.Head(selitem);
        disp(['Import Event: ' Head.FileName]); pause(0.000000000001);

        % time
        % log 파일의 시간은 날짜가 찍히지 않기 때문에
        % 밤 12시가 넘어가는 이벤트들을 보정해야 함.
        % Header의 recording start time 으로 부터 보정
        StartDate = Head.StartDate;
        StartTime = Head.StartTime;

        % start time 보다 크면 같은 날
        % start time 보다 작으면 다음 날
        [NUM,TXT] = xlsread(logfile,'A:A');
        Time = datenum(TXT);
        Time = Time - floor(Time);
        Time(Time > StartTime) = Time(Time > StartTime) + StartDate;
        Time(Time < StartTime) = Time(Time < StartTime) + StartDate + 1;

        Event.Label = EventLabel;
        Event.Time = Time;
        Event.Channel = ChanLabel;

        if ~isempty(Head.Event)
            ow = questdlg('Overwrite or Clear?','Previous Event','Overwrite','Clear','Clear');
        else
            ow = 'Clear';
        end

        if strcmp(ow, 'Clear')
            Head.Event = Event;
        else
            Head.Event = [Head.Event Event];
        end
        
        handles.Head(selitem) = Head;
        ok = 1;
    else
        ok = 0;
    end
                    
else
    msgbox('Select Files!!!','Error','error');
    ok = 0;
end