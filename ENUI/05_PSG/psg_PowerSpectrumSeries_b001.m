function psg_PowerSpectrumSeries(handles)
%----------------------------------------------------------
% Pwer Spectrum Series
%
%
% Author : Gwan-Taek Lee
% Last update : 2012. 02. 05.
%----------------------------------------------------------

parms = inputdlg({'Select Channels',...
                    'Frequency Range (Hz) - Min Max',...
                    'Mean Frequency Bins? - (Y or N)',...
                    'FFT Window Length (sec)',...
                    'Absolute, Relative or Z-Value (A, R or Z)',...
                    'Scale - Min Max, Option'},'',1,...
                    {'C3-M2','0.5 45','N','3','A',''});
%                 {'F3 F4 C3 C4 O1 O2','0.5 45','N','3','A',''});
a
if ~isempty(parms)
    
    % Prepare Input Parameter=========================================
    chan  = gui_GetParms(parms{1},'%s',' ');
    fband = gui_GetParms(parms{2}, '%f %f', ';');
    fmean = parms{3};
    win   = gui_GetParms(parms{4}, '%f', ' ');
    type  = upper(parms{5});
    scale = gui_GetParms(parms{6}, '%f %f', ' ');
        
    % Prepare spectra data============================================
    selitem = handles.i_file;
    perc    = 0.5;              % Overlap Percentage
    
    % Single file
    Head    = handles.Head(selitem);
    Data    = file_Load(Head.FileName, Head.FilePath, 'Data');
    Data    = util_DataReference(Data,Head.RefeChan);
    i_chan  = util_GetIndex(Head.ChanLabel, chan);
    [P F]   = psg_PowerSpectrum(Head,Data(i_chan,:),win,perc);
    
    P = mean(P,4); % Mean Segments in a epoch
    
    % Value type
    switch type
        case 'A'
            P = log(P);
        case 'R'
            fmax = get_objectidx(55,f);
            tot = repmat(sum(P(:,1:fmax,:),2), [1 size(P,2) 1]);
            P = log(P ./ tot);
        case 'Z'
            P = zscore(P,0,3);
    end        
    
    % Figure =========================================================
    i_fband = util_GetIndex(F, fband);
    n_chan  = length(i_chan);
    n_stage = length(Head.Stage.Label);
    stime   = Head.Stage.Time(1);
    etime   = Head.Stage.Time(end);
    row = n_chan+1;
    col = 1;
    
    ytext = 'Frequency (Hz)';
    
    figure;
    set(gcf,'nextplot','add', 'Color',[1 1 1], 'Position', [100 100 1000 800]);

    % Sleep Stage       
    subplot(row,col,1);
    for s = 1 : n_stage
        plot(Head.Stage.Time, Head.Stage.Series(:,s),...
            'linewidth',4,'color', Head.Stage.Color{s});
        hold on;
        box off;
    end
    set(gca,'YTick',1:n_stage,'YTickLabel',Head.Stage.Label);
    datetick('x','HH:MM');
    title('Sleep Structure');
    ylim([0 n_stage+1]);
    xlim([stime etime]);
        
    % Spectra Series
    if(strcmpi(fmean, 'Y'))
        
        % Mean Spectra
        P = squeeze(mean(P(:,i_fband(1):i_fband(2),:),2));
        for c = 1 : n_chan
            p = squeeze(P(c,:));           
            subplot(row, col, c+1)            
            plot(Head.Stage.Time,p);
            datetick('x','HH:MM:SS');
            title(Head.ChanLabel{i_chan(c)});
            xlim([stime etime]);
            if(~isempty(scale))
                ylim(scale);
            end
        end
        
    elseif(strcmpi(fmean, 'N'))
        
        % Frequency Spectra
        F = F(i_fband(1):i_fband(2));
        P = P(:,i_fband(1):i_fband(2),:);
        for c = 1 : n_chan
            p = squeeze(P(c,:,:));            
            subplot(row, col, c+1);
            imagesc(Head.Stage.Time,F,p);
            datetick('x','HH:MM:SS');
            title(Head.ChanLabel{i_chan(c)});
            ylabel(ytext);
            xlim([stime etime]);
            if(~isempty(scale))
                caxis(scale);
            end
            axis xy;
        end
        
    end           
    
end