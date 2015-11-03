function psg = pre_Event(psg,filename,stagelabel,stagecolor,duration)
    
    % Load excel file
    fid = fopen(filename,'r','ieee-le');
    if fid == -1,
      error('File not found ...!');
    end

    [~,stagexls] = xlsread(filename,'B:B');
    n_stage = length(stagelabel);
    n_epch = length(stagexls);
    Stage = zeros(n_epch,n_stage);
    for s = 1 : n_stage
        Stage(:,s) = (strcmp(stagexls, stagelabel{s})) * s;
    end
    Stage(Stage == 0) = nan;
    
    % read event time
    time = xlsread(filename,'A:A');
    sdate = floor(psg.Time(1));
    edate = floor(psg.Time(end));
    time(time>0.5) = time(time>0.5) + sdate;
    time(time<0.5) = time(time<0.5) + sdate + (edate - sdate);
    
    fs = psg.Header.SamplingRate(1) / psg.Header.Duration;
    iEvtStime = util_GetIndex(time(1), psg.Time);
    iEvtEtime = iEvtStime(1) + (n_epch * fs * duration) - 1;
    psg.Data = psg.Data(:,iEvtStime:iEvtEtime);
    psg.Time = psg.Time(iEvtStime:iEvtEtime);
    
    psg.Event.StageLabels = stagelabel;
    psg.Event.StageColors = stagecolor;
    psg.Event.Stage = Stage;
    psg.Event.Time = time;
    psg.Event.Duration = duration;

end