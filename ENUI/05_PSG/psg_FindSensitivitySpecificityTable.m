function psg_FindSensitivitySpecificityTable(handles)

    Head = handles.Head;
    for i=1:length(Head.ChanLabel)
        ChanLab = Head.ChanLabel{i};
        if ( strcmpi(ChanLab(1:2), 'C3') )
            break;
        end
    end
    
    parms   = inputdlg({'Channels','Freq. range', 'alpha', 'ratio', 'duration (ms)'},...
                        'Parameters setting',1,...
                        {ChanLab,'10 16','90:1:99','0.3:0.05:0.5','300:20:500'});      

    fband = [];
    alpha = [];
    ratio = [];
    duration = [];
    
    eval(['fband = [' parms{2} '];']);                    
    eval(['alpha = [' parms{3} '];']);
    eval(['ratio = [' parms{4} '];']);
    eval(['duration = [' parms{5} '];']);
    
    TABLE.col = [{'alpha'}, {'ratio'}, {'duration'},{'sensitivity'},{'specitivity'},{'#AutoDetection'},{'#ManualDetection'},{'#overlap'}];
    table = zeros(length(alpha)*length(ratio)*length(duration),8);
    n = 0;
    for i=1:length(alpha)
        for j=1:length(ratio)
            for k=1:length(duration)
                head = psg_DetectSpindleForTable(handles,ChanLab, fband, alpha(i), ratio(j), duration(k));
                [sen spec nAuto nManual nManualOverlap] = psg_getSenSpec(head);
                n = n + 1;
                table(n,:) = [alpha(i), ratio(j), duration(k), sen, spec, nAuto, nManual, nManualOverlap];
            end
        end
    end
    TABLE.table = table;
    
    save('SenSpecTable.mat', 'TABLE', '-v7.3');
    disp('Done');
    