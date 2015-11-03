function [handles, ok] = psg_SleepStage(handles)
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
global loadpath;

if (handles.n_file > 0) && strcmpi(handles.mode, 'file')

    logpath = uigetdir(loadpath);
    
    % 다이얼로그에서 취소 누르면 빠져 나가기
    if (logpath == 0)
        ok = 0;
        return;
    end
    
    S = {'TWIN','EMBLA'};
    logtype = listdlg('ListString', S);
    logtype = S{logtype};
    
    list = dir(loadpath);
    
    S2 = cell(1,length(list)-2);
    for i=3:length(list)
        S2{i-2} = list(i).name;
    end
    
    logfile = listdlg('ListString', S2);
    logfile = S2{logfile};
    
    parms   = inputdlg({'Sleep Stages', 'Stage Colors', 'Duration (sec)'},...
                        'Sleep Stages',1,...
                        {'W N1 N2 N3 R','K M G B R','30'});        
                       
%     if ~isempty(parms) && ischar(logpath) && ~isempty(logext)
    if ~isempty(parms) && ischar(logpath)
        StageLabel = gui_GetParms(parms{1}, '%s', ' ');
        ColorLabel = gui_GetParms(parms{2}, '%s', ' ');
        Duration = gui_GetParms(parms{3}, '%f', ' ');

        selitem = handles.i_file;
        for i = 1 : length(selitem)
            Head = handles.Head(selitem(i));
            disp(['Sleep Stage: ' Head.FileName]); pause(0.000000000001);
%             logfile = [logpath '\' strtok(Head.FileName,'.') logext{1}];

            [Time stagexls] = psg_ReadStageXLS([loadpath logfile], logtype);
%             [~,stagexls] = xlsread(logfile,'B:B');

% =====141223 stagexls 불필요 marker 제거 ===============
Time_b = Time; % backup
stagexls_b = stagexls; % backup

for n = length(Time) : -1 : 1
    if ~strcmp(stagexls(n), StageLabel{1}) && ~strcmp(stagexls(n), StageLabel{2})...
        && ~strcmp(stagexls(n), StageLabel{3}) && ~strcmp(stagexls(n), StageLabel{4})...
        && ~strcmp(stagexls(n), StageLabel{5})
        stagexls(n) = [];
        Time(n) = [];
    end
end
% ___________________________________________

            n_stage = length(StageLabel);
            n_epoch = length(stagexls);

            % series
            Series = zeros(n_epoch,n_stage);
            for s = n_stage : -1 : 1
                Series(:,s) = (strcmp(stagexls(:), StageLabel{s})) * s;
            end
            Series(Series == 0) = nan;

            % time
            % log 파일의 시간은 날짜가 찍히지 않기 때문에
            % 밤 12시가 넘어가는 이벤트들을 보정해야 함.
            % Header의 recording start time 으로 부터 보정
            StartDate = Head.StartDate;
            StartTime = Head.StartTime;

            % start time 보다 크면 같은 날
            % start time 보다 작으면 다음 날
%             Time = xlsread(logfile,'A:A');
%             Time(Time > StartTime) = Time(Time > StartTime) + StartDate;
%              ===> Fixed Bug.
            Time(Time >= StartTime) = Time(Time >= StartTime) + StartDate;
            Time(Time < StartTime) = Time(Time < StartTime) + StartDate + 1;

%             % =====141223 스테이지 nan 제거 ===============
%             max_stage_length = length(Series);
%             for n = 1:max_stage_length % 그 행을 없애자. 전체 사이즈가 줄어듬
%                 nn = max_stage_length - n +1;
%                 if 0 == max(~isnan(Series(nn,:)))
%                     Series(nn,:) = [] ; 
%                 end
%             end
%             % ___________________________________________
            Stage.Label = StageLabel;
            Stage.Color = ColorLabel;
            Stage.Duration = Duration;
            Stage.Series = Series;
            Stage.Time = Time;

            handles.Head(selitem(i)).Stage = Stage;

        end
        ok = 1;
        disp('Staging Done.');
    else
        ok = 0;
    end
                    
else
    msgbox('Select Files!!!','Error','error');
    ok = 0;
end

% % =====141223 스테이지 nan 제거 ===============
% max_stage_length = length(Head.Stage.Series);
% for n = 1:max_stage_length % 그 행을 없애자. 전체 사이즈가 줄어듬
%     nn = max_stage_length - n +1;
%     if 0 == max(~isnan(Head.Stage.Series(nn,:)))
%         Head.Stage.Series(nn,:) = [] ; 
%     end
% end
% % ___________________________________________