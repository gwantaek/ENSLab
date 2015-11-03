function [time stage] = psg_ReadStageXLS(logfile, type)
%----------------------------------------------------------
%
% type   : 'twin', 'embla'
%
% Author : Gwan-Taek Lee, edited by Chany Lee
% Last update : 2012. 06. 11.
%----------------------------------------------------------
   
global Head
global MarkedSpindle;
global SpindleArray;

    MarkedSpindle.color = 'b';
    MarkedSpindle.Label = 'Manual';
    MarkedSpindle.Time = [];
    MarkedSpindle.Channel = {'Cz'};
    MarkedSpindle.EpochNum = [];
    MarkedSpindle.Duration = [];
    MarkedSpindle.nSpindle = 0;

%     Event.Label = 'Manual';
%     Event.color = 'b';
%     time = [];
%     Event.Channel = {'Cz'};
%     Sample = {};
%     duration = {};

    nSpindle = 0;
    
    switch (upper(type))
        case 'TWIN'
            
            [NUMERIC,TXT]=xlsread(logfile);
            n = 0;
            k = 0;
            len = size(NUMERIC,1);
            
            for i=1:len
                str = TXT{i,2};
                if (length(str) > 4)
                    if strcmp(str(1:5), 'Stage')
                        strLen = length(str);
                        if( strLen > 15 )
                        else
                            n = n + 1;
                            epochNum(n) = NUMERIC(i,1);
                            times(n) = cellstr(TXT{i,1});
                            stages(n) = cellstr(str(9:strLen));
                        end
                    end
                end
                if(length(str) > 6)
                    if(strcmp(str(1:7), 'Spindle'))
                        if( strcmp(str(9:12), 'Mark'))
                        else
                            kkk = 15;
                            nSpindle = nSpindle + 1;
                            while(1)
                                if(strcmp(str(kkk:kkk+2), 'sec'))
                                    break;
                                else
                                    kkk = kkk + 1;
                                end
                            end
                            MarkedSpindle.Duration(nSpindle) = str2num(str(15:kkk-1));
                            MarkedSpindle.EpochNum(nSpindle) = NUMERIC(i,1);
                            Time_sp(nSpindle) = cellstr(TXT{i,1});                            
                        end
                    end
                end
            end
            lastEpoch = epochNum(n);
            timexls = zeros(1, lastEpoch);
            stagexls = cell(1, lastEpoch);
            s1 =  datenum('00:00:01.000','HH:MM:SS.FFF') - datenum('00:00:00.000','HH:MM:SS.FFF');
            s30 = datenum('00:00:30.000','HH:MM:SS.FFF') - datenum('00:00:00.000','HH:MM:SS.FFF');
            for i=1:n-1
                presentNum = epochNum(i);
                nextNum = epochNum(i+1);
                for j=presentNum:nextNum-1
                    timexls(j) =  datenum(times(i),'HH:MM:SS.FFF') - datenum('00:00:00.000','HH:MM:SS.FFF') + s30*(j-presentNum);
                    stagexls(j) = stages(i);
                end
            end
            for i=1:lastEpoch
                if timexls(i) ~= 0
                    break;
                end
            end
            timexls = timexls(i:lastEpoch);
            stagexls = stagexls(i:lastEpoch);
            time = timexls;
            stage = stagexls';
            
            MarkedSpindle.nSpindle = nSpindle;
            
            if( nSpindle > 0 )    
                for i=1:nSpindle
                   Time_Sp_double(i) =  datenum(Time_sp(i),'HH:MM:SS.FFF')- datenum('00:00:00.000','HH:MM:SS.FFF');
%                    Time_Sp_double(i) =  s1*MarkedSpindle.Duration(i)+ datenum(Time_sp(i),'HH:MM:SS.FFF')- datenum('00:00:00.000','HH:MM:SS.FFF');
                end
                MarkedSpindle.Time = Time_Sp_double;
            end

        case 'EMBLA'
             if ( strcmpi(logfile(end-2:end),'txt') )
                fh1 = fopen(logfile,'r');
                while(1)
                    fline = fgetl(fh1);
                    if( length(fline)>20 && strcmp(fline(1:5), 'Sleep') )
                        break;
                    end
                end  
                n = 0;
                while(~feof(fh1))
                    n = n + 1;
                    fline = fgetl(fh1);
                    tabIndices = isspace(fline);
                    tabIndices = find(tabIndices==1);
                    status = fline(1:tabIndices(1)-1);
                    position = fline(tabIndices(1)+1:tabIndices(2)-1);                        
%                     date = fline(tabIndices(2)+1:tabIndices(2)+10);
                    time = fline(tabIndices(2)+1:tabIndices(2)+11);
%                     times(n) = datenum(date,'yyyy-mm-dd')+datenum(time(1:8),'hh:mm:ss')-- datenum('00:00:00.000','HH:MM:SS.FFF');
                    times(n) = datenum(time,'HH:MM:SS PM') - datenum('00:00:00','HH:MM:SS');
                    stages(n) = cellstr( fline(tabIndices(4)+1:tabIndices(5)-1) );
                end
                fclose(fh1);
                time = times;
                stage = stages;
                
            else
                timexls = xlsread(logfile, 'A:A');
                [~,stagexls] = xlsread(logfile,'B:B');
                time = timexls;
                stage = stagexls;
            end
    end 
    
end