function [handles ok] = psg_SleepAtoniaIndex(handles)
%----------------------------------------------------------
% Calculate sleep atonia index
%
% Head
% Data
%
% Author : Chany Lee
% Last update : 2014. 10. 24
%----------------------------------------------------------

Head = handles.Head;

for i=1:length(Head.Stage.Time)
    index = find(isnan(Head.Stage.Series(i,:)) == 0);
    if( isempty(index) )
        break;
    else
        stages(i) = find(isnan(Head.Stage.Series(i,:)) == 0);
    end
end

 parms = inputdlg({'Select Channels'},'',1,...
                     {'Lower.Left-Lower'});
%                  {''});
                 
if isempty(parms)
    msgbox('EMG channel name is required.');
else
    chan = gui_GetParms(parms{1}, '%s', ' ');
    for i=1:length(Head.ChanLabel)
        if( strcmpi(chan, Head.ChanLabel{i}) )
            selectedChan = i;
            break;
        end
    end
    
    if ~exist('selectedChan')
        ok = 0;
        return;
    end
    data = file_Load(Head.FileName, Head.FilePath, 'Data');
    data = util_DataReference(data, Head.RefeChan);
    
    EMG = data(selectedChan,:);
    clear data;
    
    EMG_filtered = my_filter(EMG,[10 100], Head.SampRate);
    tempNotch = my_filter(EMG_filtered, [59 61], Head.SampRate);
    EMG_filtered = EMG_filtered - tempNotch;
    EMG_abs = abs(EMG_filtered);
    clear EMG_filtered;
    nMiniEpoch = Head.TimeNum/Head.SampRate;
    
    for i=1:nMiniEpoch
        avgAMP(i) = mean(EMG_abs(((i-1)*Head.SampRate+1:i*Head.SampRate)));
    end
    figure; plot(avgAMP);
    for i=31:nMiniEpoch-30
        mini = min(avgAMP(i-30:i+30));
        avgAMP(i) = avgAMP(i) - mini;
    end

    amplitudes = zeros(5,20); % the number of 1-s epochs with atonia
    n = 0;
    for i=1:length(stages)
        for j=1:30
            n = n + 1;   
            for k=1:20
                if( ( avgAMP(n) > (k-1) ) && ( avgAMP(n) < k ) )
                    amplitudes(stages(i),k) = amplitudes(stages(i),k) + 1;
                    break;
                end
                amplitudes(stages(i),20) = amplitudes(stages(i),20) + 1;
            end
        end
    end
    
    output = cell(21,6);
    output(1,1) = {'uV'};
    output(1,2:6) = {'W', 'N1', 'N2', 'N3', 'R'};
    output(2:21,2:6) = num2cell(amplitudes');
    for i=1:19
        output(i+1,1) = { [num2str(i-1) '~' num2str(i)] };
    end
    output(21,1) = {'>19'};
    xlswrite(['EMG_analysis_' Head.FileName(1:end-4) '.xls'], output);
%     indices_0_1 = find( avgAMP < 1 );
%     indices_1_2 = find((avgAMP >= 1)  && (avgAMP <= 2) );
%     indices_2_inf = find( avgAMP > 2);
    figure; plot(avgAMP);

    atonia_index = amplitudes(:,1)./sum(amplitudes(:,[1 3:20]),2);
    
%     figure; bar(atonia_index(2:5));
    figure; bar(atonia_index(1:5));
%     set(gca, 'xticklabel', {'N1', 'N2', 'N3', 'R'});
    set(gca, 'xticklabel', {'W','N1', 'N2', 'N3', 'R'});
    ylabel('Atonia Index');

end

ok = 1;