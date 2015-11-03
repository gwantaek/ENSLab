function gui_UpdateFileStatus(handles)
%----------------------------------------------------------
% Update Status
%
%
% Author : Gwan-Taek Lee
% Last update : 2012. 02. 04
%----------------------------------------------------------
    
    if handles.n_file == 0
        status = 'No file';       
    else      
        selitem = length(handles.i_file);

        if selitem > 1  
            status = [num2str(selitem) ' files are selected.'];
        else
            Head = handles.Head(handles.i_file);

            % Channels Number
            datachan = num2str(length(Head.DataChan));
            refechan = num2str(length(Head.RefeChan));
            evntchan = num2str(length(Head.EvntChan));

            evntlab = [];
            stagelab = [];
            stagecol = [];
            freq = [];

            % Event Label            
            if ~isempty(Head.Event)                
                for e = 1 : length(Head.Event)
                    evntlab = [evntlab Head.Event(e).Channel{1} '-' Head.Event(e).Label ' '];
                end                
            end

            % Stages Label & Color
            if ~isempty(Head.Stage)
                stagelab = util_Cell2Str(Head.Stage.Label, 'h');
                stagecol = util_Cell2Str(Head.Stage.Color, 'h');
            end

            % REC Start / End Time
            stime = Head.StartDate + Head.StartTime;
            etime = util_GetOffTime(stime, Head.SampRate, Head.TimeNum);

            % Frequency
            if ~isempty(Head.Freq)
                freq = [];
            end

            status = ...
                [
                 'File Type : '   Head.FileType           char(13)...
                 'File Name : '   Head.FileName           char(13)...
                 'File Path : '   Head.FilePath           char(13)...
                 'Start Time : '  datestr(stime)          char(13)...
                 'End Time : '    datestr(etime)          char(13)...
                 'Data Chan : '   datachan                char(13)...
                 'Refe Chan : '   refechan                char(13)...
                 'Event Chan : '  evntchan                char(13)...
                 'Time Frame : '  num2str(Head.TimeNum)   char(13)...
                 'Samp Rate : '   num2str(Head.SampRate)  char(13)...
                 'Filter : '      Head.Filter             char(13)...
                 'Freq : '        freq                    char(13)... 
                 'Event : '       evntlab                 char(13)...
                 'Stage : '       stagelab                char(13)...
                 'Stage Color : ' stagecol                char(13)];
        end
    end
         
    set(handles.E_Status, 'String', status);   
end
