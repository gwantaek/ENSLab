function PlotScrollData(h, data, sens, chan, time, tick, event, stage, envel)
%----------------------------------------------------------
% Time Scroll Event
%
% h         : The handle of Axes
% data      : Time Series (Chan X Time)
% sens      : Amplitude Sensitivity
% chan      : Cell Type
% time      : Double Type
% tick      : Time Tick length
%
% Author : Gwan-Taek Lee
% Last update : 2012. 2. 6
%----------------------------------------------------------
global detectionParam;
global Head;

    n_chan = size(data,1);
    n_time = size(data,2);
    
    % Set Time Tick
    xtick = 0:tick:(n_time-1);
    xticklab = {datestr(time(xtick+1),'HH:MM:SS')};
    
    % Adjust Sensitivity
    ytick = (1:n_chan) * sens;
    yticklab = chan;
    for c = 1 : n_chan
        data(c,:) = data(c,:) + ytick(c);
    end
    if envel
        chan  = util_GetIndex(Head.ChanLabel, detectionParam.ChanLab);
        X = data(chan,:);
        X = my_filter(X,detectionParam.fband,Head.SampRate);
        X = abs(hilbert(X));
        X = X + ytick(chan);
    end
    
    
    % Plot Segmented Scroll Data
    plot(h, data', 'color', [0 0 0]);
    if envel
        hold on;
        plot(h, X, 'g', 'LineWidth', 2);
        hold off;
    end
      
    % Event Mapping
    if ~isempty(event)
        for e = 1 : length(event)
            evt = event{e};
            text(evt{1}, evt{2}, evt{3}, 'FontSize', 10, 'Color', evt{6});
            duration = evt{4};
            for k = 1:length(duration)
                dur = duration{k};
                XX(1) = dur(1);
                XX(2) = dur(end);
                YYY = evt{5};
                YY(1) = YYY(1);
                YY(2) = YY(1);
%                 if( length(XX) ~= length(YY) )
%                     disp('ddd');
%                 end
                line(XX,YY,'LineWidth', 2, 'Color', evt{6});
            end
        end
    end
    
    % Stage Mapping
    if ~isempty(stage)
        text(stage{1}, stage{2}, stage{3}, 'FontSize', 10,...
            'Color', 'r', 'BackgroundColor', 'y');
    end
    
    set(gca, 'XAxisLocation',    'top');
    set(gca, 'xtick',            xtick);
    set(gca, 'xticklabel',       xticklab);
    set(gca, 'xlim',             [0 n_time-1]);
    set(gca, 'ytick',            ytick);
    set(gca, 'yticklabel',       yticklab);
    set(gca, 'ylim',             [ytick(1)-sens ytick(end)+sens]);
    set(gca, 'XGrid',            'on');
    set(gca, 'ydir',             'reverse');
    set(gca, 'box',              'off');
        
end