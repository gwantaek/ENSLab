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
                    'Sample Length(/hour)'},'',1,...
                    {'C3-M2 C4-M1','W N1 N2 N3 R','0.5 2; 4 7;8 12;13 30;30 45','3','A','1.5'});
%                     {'F3-M2','W N1 N2 N3 R','0.5 2; 4 7;8 12;13 30;30 45','3','A','1.5'});
% F3-M2 F4-M1 C3-M2 C4-M1 P3-M2 P4-M1 O1-M2 O2-M1 E2-M1 E1-M2 // 길어서백업
% 행 추가하면 오류나서 이거 마지막꺼 날리고 바꿈 'Scale - Min Max, Option'

if ~isempty(parms)
    
    % Prepare Input Parameter=========================================
    chan  = gui_GetParms(parms{1},'%s',' ');
    stage = gui_GetParms(parms{2},'%s',' ');
    fband = gui_GetParms(parms{3}, '%f %f', ';');
    win   = gui_GetParms(parms{4}, '%f', ' ');
    type  = upper(parms{5});
    spl_length = gui_GetParms(parms{6}, '%f', ' ');
%     scale = gui_GetParms(parms{6}, '%f %f', ' ');
    scale = [] ; % 위에서 날려먹었으니 입력값은 임의로 넣음
%     scale = 8 ; % 필요시 이걸로 y축 고정

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
            real_P = P; % 150401 real value, ever u need!
            P = log(P); % 여기서 Log를 해주는구나.. 자연로그
        case 'R'
            fmax = util_GetIndex(55,F);
            tot = repmat(sum(P(:,1:fmax,:),2), [1 size(P,2) 1]);
            real_P = (P ./ tot);
            P = log(P ./ tot);
    end

    % Sample Length=========================================
    %     spl_length 는 1,2,3.. 중의 하나
    % n_epoch = length(handles.Head.Stage.Time);  % epoch max값
    n_epoch = length(Head.Stage.Time);  % epoch max값
    t1to6 = [1 2 3 4 5 6];
    time_epoch_sequence = t1to6 * 120 * spl_length ; % 이걸 단위별로 subplot할것
    n_plot = sum(time_epoch_sequence < n_epoch) ; % subplot개수가 나옴
%     start_length = 1 ; 
%     end_length = 0 ;  % 루푸문 들어가기 전에 디폴트로..


    % Figure =========================================================
    i_stage = util_GetIndex(Head.Stage.Label, stage);
    i_fband = util_GetIndex(F, fband);

    n_chan  = length(i_chan);    % 체널수
    n_stage = length(i_stage);
    n_fband = size(i_fband,1);

%     row = ceil(n_chan/2);
    row = ceil(n_plot/2) ;
    col = 2 ;
  
% ------------------------------------------------------
        for c = 1:n_chan;
        start_length = 1 ;
        end_length = 0 ;
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

            F_temp = F(i_fband(1):i_fband(2));
            P_temp = P(:,i_fband(1):i_fband(2),:);
            cc = i_chan ; 
%             start_length = 1 ; 
            for t_plot = 1 : n_plot            
                start_length = end_length+1 ; 
                end_length = time_epoch_sequence(t_plot) ; 
                for s = 1 : n_stage  % for s = 1 : n_stage
                    stage = i_stage(s);  % 몇번째..인지물어보는데 체널로 바꿔야
                    epch = Head.Stage.Series(:,stage) == stage; 
                    p = mean(P_temp(c,:,epch(start_length:end_length)),3);
                    subplot(row, col, t_plot);  % 여기서 c대신 t_plot
                    plot(F_temp,p,'linewidth',2,'color',Head.Stage.Color{stage});   % 여기서 Plot
    %                 title(Head.ChanLabel{i_chan(c)});  % 이걸 바꿔줘야함
    %                 title([Head.ChanLabel{i_chan(c)},'   ', num2str( (start_length-1) / 120) , ' ~ ', num2str(end_length / 120) , 'h']); 
                    xlabel(xtext); ylabel(ytext);
                    hold on;
                end
    %             subplot(row, col, t_plot);
    % %             h = bar(p, 1.5);          
    %             plot(F_temp,p,'linewidth',2,'color',Head.Stage.Color{stage});   % 여기서 Plot
    % %             set(gca, 'xticklabel',xticklab);
    % %             title(Head.ChanLabel{n_plot(t_plot)});
                title([cell2mat(chan(c)),'   ', num2str( (start_length-1) / 120) , ' ~ ', num2str(end_length / 120) , 'h']);
                xlabel(xtext); ylabel(ytext);

           end
           if(~isempty(scale))
               ylim(scale);
           end
               xlim([F_temp(1) F_temp(end)]);
               box off;
            legend('Wake', 'N1', 'N2', 'N3', 'REM')  % legend(범례)는 여기 하나만 넣으면 될듯
        else
            % Bar Plot

%             c = 1 ; % 이전 loop문의 잔해, 더미
            for t_plot = 1 : n_plot            
                start_length = end_length+1 ; 
                end_length = time_epoch_sequence(t_plot) ; 

                p = zeros(n_fband,n_stage);
                xticklab = cell(1,n_fband);
                for b = 1 : n_fband
                    for s = 1 : n_stage
                        stage = i_stage(s);
                        epch = Head.Stage.Series(:,stage) == stage; 
    %                   `150330 설정 시간에 따라 epoch를 선별한다. ========================
                        epch_interval = epch;
                        epch_seq = [0 time_epoch_sequence];
                        epch_interval(1:epch_seq(t_plot)) = 1<0 ;
                        epch_interval(epch_seq(t_plot+1):end) = 1<0 ;
    %                   _________________________________________________________________
    %                     p(b,s) = mean(mean(P(c,i_fband(b,1):i_fband(b,2),epch),2),3);
                        p(b,s) = mean(mean(P(c,i_fband(b,1):i_fband(b,2),epch_interval),2),3);
                    subplot(row, col, t_plot);
                    h = bar(p, 1.5);            
                    xlabel(xtext); ylabel(ytext);

                    end                
                    xticklab{b} = [num2str(fband(b,1)) '-' num2str(fband(b,2))];                
                end            

%                 subplot(row, col, t_plot);
%                 h = bar(p, 1.5);            
                set(gca, 'xticklabel',xticklab);
    %             title(Head.ChanLabel{n_plot(t_plot)});
                title([cell2mat(chan(c)),'   ', num2str( (start_length-1) / 120) , ' ~ ', num2str(end_length / 120) , 'h']);
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
            legend('Wake', 'N1', 'N2', 'N3', 'REM')  % legend(범례)는 여기 하나만 넣으면 될듯
        end
    end
end