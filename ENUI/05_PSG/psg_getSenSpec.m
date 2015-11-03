function [sensitivity specificity nAuto nManual nManualOverlap] = psg_getSenSpec(Head)

AnalysisTime = {'00:31:47'; '01:32:01'};

Series = Head.Stage.Series;
StageTime = Head.Stage.Time;
StartTime = Head.StartTime;
StartDate = Head.StartDate;

EventAutoDetect = Head.Event(1); 
EventManualDetect = Head.Event(2);

N2Time_num = StageTime(Series(:,3) == 3);
N2Time_str = datestr(N2Time_num, 'HH:MM:SS');

nN2stage = length(N2Time_num);
nEpoch = nN2stage*10;

n = 0;
ThreeSec = datenum('00:00:03','HH:MM:SS')-datenum('00:00:00','HH:MM:SS');
for ii=1:nN2stage
    for jj=1:10
        n = n + 1;
        EpochTime_num(n) = N2Time_num(ii) + (jj-1)*ThreeSec;
    end
end
EpochTime_str = datestr(EpochTime_num, 'HH:MM:SS');

SpindleDetection = zeros(nEpoch,2);

OneSec =  datenum('00:00:01','HH:MM:SS')-datenum('00:00:00','HH:MM:SS');
Time = EventAutoDetect.Time;
Time = Time - StartDate;
EpochTime_num = EpochTime_num - StartDate;
for ii=1:length(Time)
    for jj=1:nEpoch-1
        if( EpochTime_num(jj)<Time(ii) && EpochTime_num(jj+1)>Time(ii))
            SpindleDetection(jj,1) = 1; % autodetection
        end  
    end
end

nManualOverlap = 0;
Time = EventManualDetect.Time;
Time = Time - StartDate;
for ii=1:length(Time)
    for jj=1:nEpoch-1
        if( EpochTime_num(jj)<Time(ii) && EpochTime_num(jj+1)>Time(ii))
            if (SpindleDetection(jj,2) == 1)
                nManualOverlap = nManualOverlap + 1;
            end
            SpindleDetection(jj,2) = 1; % Manual detection
        end  
    end
end

START = datenum(cellstr(AnalysisTime(1)),'HH:MM:SS');
END = datenum(cellstr(AnalysisTime(2)),'HH:MM:SS');
EpochTime_num = datenum(EpochTime_str,'HH:MM:SS');
for jj=1:nEpoch-1
    if( EpochTime_num(jj)<START && EpochTime_num(jj+1)>START)
        StartIndex = jj;
    end  
    if( EpochTime_num(jj)<END && EpochTime_num(jj+1)>END)
        EndIndex = jj-1;
    end  
end

if (START < EpochTime_num(1))
    StartIndex = 1;
end
if (END > EpochTime_num(end))
    EndIndex = length(EpochTime_num);
end

SpindleDetection = SpindleDetection(StartIndex:EndIndex,:);

nAuto = sum(SpindleDetection(:,1));
nManual = sum(SpindleDetection(:,2));

nTP = 0;
nTN = 0;
nFP = 0;
nFN = 0;
for jj = 1:size(SpindleDetection,1)
    manual = SpindleDetection(jj,2);
    auto = SpindleDetection(jj,1);
    if( (auto == 1) && (manual == 1))
        nTP = nTP + 1;
    end
    if( (auto == 1) && (manual == 0))
        nFP = nFP + 1;
    end
    if( auto == 0 && manual == 1)
        nFN = nFN + 1;
    end
    if(auto == 0 && manual == 0)
        nTN = nTN + 1;    
    end
end

sensitivity = nTP/(nTP+nFN);
specificity = nTN/(nFP+nTN);
posPredictive = nTP/(nTP+nFP);
negPredictive = nTN/(nFN+nTN);
