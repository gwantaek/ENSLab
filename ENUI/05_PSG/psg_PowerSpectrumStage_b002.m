function psg_PowerSpectrumStage(handles)
%----------------------------------------------------------
% Pwer Spectrum Stage
%
%
% Author : Gwan-Taek Lee
% Last update : 2012. 02. 05.
%----------------------------------------------------------

parms = inputdlg({'Select Channels',...
                    'Select Stages',...
                    'Frequency Range (Hz) - Min Max;',...
                    'FFT Window Length (sec)',...
                    'Absolute or Relative (A or R)',...
                    'Sample Length(1h,2h,4h,half,All)'},'',1,...
                    {'F3-M2','W N1 N2 N3 R','0.5 45','3','A','1 max'});
% F3-M2 F4-M1 C3-M2 C4-M1 P3-M2 P4-M1 O1-M2 O2-M1 E2-M1 E1-M2 // 길어서백업
% 행 추가하면 오류나서 이거 마지막꺼 날리고 바꿈 'Scale - Min Max, Option'

if ~isempty(parms)
    
    % Prepare Input Parameter=========================================
    chan  = gui_GetParms(parms{1},'%s',' ');
    stage = gui_GetParms(parms{2},'%s',' ');
    fband = gui_GetParms(parms{3}, '%f %f', ';');
    win   = gui_GetParms(parms{4}, '%f', ' ');
    type  = upper(parms{5});
    spl_length = gui_GetParms(parms{6}, '%f %f', ' ');
%     scale = gui_GetParms(parms{6}, '%f %f', ' ');
    scale = [] ; % 위에서 날려먹었으니 입력값은 임의로 넣음
%     scale = 8 ;
    
   
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
            fmax = util_GetIndex(55,F);
            tot = repmat(sum(P(:,1:fmax,:),2), [1 size(P,2) 1]);
            P = log(P ./ tot);
    end
    
    % Figure =========================================================
    i_stage = util_GetIndex(Head.Stage.Label, stage);
    i_fband = util_GetIndex(F, fband);

    n_chan  = length(i_chan);
    n_stage = length(i_stage);
    n_fband = size(i_fband,1);
    
    row = ceil(n_chan/2);
    col = 2;

% Sample Length=========================================
%     spl_length = [1 400];  % 우선은 임의값으로 한다.
    start_length = spl_length(1) ; 
%     end_length = spl_length(2) ;  % 논리연산으로 공백의 경우 대비, 삭제함
    if(length(spl_length)==2)
        end_length = spl_length(2) ; 
    else
        end_length = length(Head.Stage.Time) ; 
    end
% 
%     
% ------------------------------------------------------
        
    xtext = 'Frequency (Hz)';
    if(strcmp(type,'A'))
        ytext = 'Absolute Power (㎶^2/Hz)';
    elseif(strcmp(type,'R'))
        ytext = 'Relative Power (㎶^2/Hz)';
    end
    
    figure;
    set(gcf,'nextplot','add', 'Color',[1 1 1], 'Position', [100 100 1000 800]);
    
    if(n_fband < 2)
        % Spectrum Plot
        
        F = F(i_fband(1):i_fband(2));
        P = P(:,i_fband(1):i_fband(2),:);
        
        for c = 1 : n_chan
            for s = 1 : n_stage
                stage = i_stage(s);
                epch = Head.Stage.Series(:,stage) == stage; 
                p = mean(P(c,:,epch(start_length:end_length)),3);
%                 p = mean(P(c,:,epch),3);
                subplot(row, col, c);
                plot(F,p,'linewidth',2,'color',Head.Stage.Color{stage});   % 여기서 Plot
                title(Head.ChanLabel{i_chan(c)});
                xlabel(xtext); ylabel(ytext);
                hold on;
            end
            if(~isempty(scale))
                ylim(scale);
            end
            xlim([F(1) F(end)]);
            box off;
        end
      legend('Wake', 'N1', 'N2', 'N3', 'Rem')  % legend(범례)는 여기 하나만 넣으면 될듯
    else
        % Bar Plot
        for c = 1 : n_chan
            
            p = zeros(n_fband,n_stage);
            xticklab = cell(1,n_fband);
            for b = 1 : n_fband
                for s = 1 : n_stage
                    stage = i_stage(s);
                    epch = Head.Stage.Series(:,stage) == stage; 
                    p(b,s) = mean(mean(P(c,i_fband(b,1):i_fband(b,2),epch),2),3);
                end                
                xticklab{b} = [num2str(fband(b,1)) '-' num2str(fband(b,2))];                
            end            
            
            subplot(row, col, c);
            h = bar(p, 1.5);            
            set(gca, 'xticklabel',xticklab);
            title(Head.ChanLabel{i_chan(c)});
            xlabel(xtext); ylabel(ytext);
            if(~isempty(scale))
                ylim(scale);
            end
            box off;

            % Set bar colors
            for s = 1 : n_stage
                stage = i_stage(s);
                set(h(s), 'facecolor', Head.Stage.Color{stage});
            end
        end        
    end
    
% % ================================여기서 추가로 Plot ============
%     
%     figure;
%     set(gcf,'nextplot','add', 'Color',[1 1 1], 'Position', [100 100 1000 800]);
%     
%     if(n_fband < 2)
%         % Spectrum Plot
%         
%         F = F(i_fband(1):i_fband(2));
%         P = P(:,i_fband(1):i_fband(2),:);
%         
%         for c = 1 : n_chan
%             for s = 1 : n_stage
%                 stage = i_stage(s);
%                 epch = Head.Stage.Series(:,stage) == stage;
%                 p = mean(P(c,:,epch),3);
%                 subplot(row, col, c);
%                 plot(F,p,'linewidth',2,'color',Head.Stage.Color{stage});
%                 title(Head.ChanLabel{i_chan(c)});
%                 xlabel(xtext); ylabel(ytext);
%                 hold on;
%             end
%             if(~isempty(scale))
%                 ylim(scale);
%             end
%             xlim([F(1) F(end)]);
%             box off;
%         end
%     else
%         % Bar Plot
%         for c = 1 : n_chan
%             
%             p = zeros(n_fband,n_stage);
%             xticklab = cell(1,n_fband);
%             for b = 1 : n_fband
%                 for s = 1 : n_stage
%                     stage = i_stage(s);
%                     epch = Head.Stage.Series(:,stage) == stage;
%                     p(b,s) = mean(mean(P(c,i_fband(b,1):i_fband(b,2),epch),2),3);
%                 end                
%                 xticklab{b} = [num2str(fband(b,1)) '-' num2str(fband(b,2))];                
%             end            
%             
%             subplot(row, col, c);
%             h = bar(p, 1.5);            
%             set(gca, 'xticklabel',xticklab);
%             title(Head.ChanLabel{i_chan(c)});
%             xlabel(xtext); ylabel(ytext);
%             if(~isempty(scale))
%                 ylim(scale);
%             end
%             box off;
% 
%             % Set bar colors
%             for s = 1 : n_stage
%                 stage = i_stage(s);
%                 set(h(s), 'facecolor', Head.Stage.Color{stage});
%             end
%         end        
%     end
end