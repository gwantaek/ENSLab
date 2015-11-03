%% 900_KIA

load './31_LGT_DATA/900_KJA_Spindle.mat';

clear epoch P;

Fs = 400;
n_chan = 4; % F3 F4 C3 C4
epoch_size = 1000; % ms
base = 10; % 스핀들 시작 전 Gap (ms)

% Get Spindle Epochs
i = 1;
for c = 1 : n_chan
    for t = 1 : length(spindle.Time)
        ts = util_GetOffIndex(stime,Fs,spindle.Time(t));
        epoch(i,:) = Data(c, ts-(base/(1000/Fs))+1:ts+(epoch_size/(1000/Fs)));    % 400 point
        i = i + 1;
    end
end


% Get Powerspectrum of Spindles
[P, f] = lgt_powerspectrum(epoch,Fs,2,[],'abs');
max_hz = 30;
idx = lgt_find_index(max_hz, f);
% Get Relative Power
P = P(:,1:idx) ./ repmat(sum(P(:,1:idx),2),[1,length(1:idx)]);


% Figure parameter
xlim1 = [1 400];
ylim1 = [-100 100];

xlim2 = [0 max_hz];
ylim2 = [0 0.5];

xtick1 = [1 200 400];
ytick1 = [-100 100];

xtick2 = [0 4 12 20 30];
ytick2 = [0 0.5];

f_range = 1:20;     % ~30 Hz


% Figure F3
i = 1;
figure;
for e = 1 : 15
    subplot(5,6,i);
    plot(epoch(e,:)), xlim(xlim1); ylim(ylim1);
    set(gca, 'XTick', xtick1, 'YTick', ytick1, 'YDir', 'reverse');
    i = i + 1;
    
    subplot(5,6,i);
    plot(f(f_range), P(e,f_range), 'r'); xlim(xlim2); ylim(ylim2)
    set(gca, 'Xtick', xtick2, 'YTick', ytick2);
    i = i + 1;
end

% Figure F4
i = 1;
figure;
for e = 16 : 30
    subplot(5,6,i);
    plot(epoch(e,:)), xlim(xlim1); ylim(ylim1);
    set(gca, 'XTick', ytick1, 'YTick', ytick1, 'YDir', 'reverse');
    i = i + 1;
    
    subplot(5,6,i);
    plot(f(f_range), P(e,f_range), 'r'); xlim(xlim2); ylim(ylim2)
    set(gca, 'Xtick', xtick2, 'YTick', ytick2);
    i = i + 1;
end

% Figure C3
i = 1;
figure;
for e = 31 : 45
    subplot(5,6,i);
    plot(epoch(e,:)), xlim(xlim1); ylim(ylim1);
    set(gca, 'XTick', ytick1, 'YTick', ytick1, 'YDir', 'reverse');
    i = i + 1;
    
    subplot(5,6,i);
    plot(f(f_range), P(e,f_range), 'r'); xlim(xlim2); ylim(ylim2)
    set(gca, 'Xtick', xtick2, 'YTick', ytick2);
    i = i + 1;
end

% Figure C4
i = 1;
figure;
for e = 46 : 60
    subplot(5,6,i);
    plot(epoch(e,:)), xlim(xlim1); ylim(ylim1);
    set(gca, 'XTick', ytick1, 'YTick', ytick1, 'YDir', 'reverse');
    i = i + 1;
    
    subplot(5,6,i);
    plot(f(f_range), P(e,f_range), 'r'); xlim(xlim2); ylim(ylim2)
    set(gca, 'Xtick', xtick2, 'YTick', ytick2);
    i = i + 1;
end

% 10~16 Hz Peak Value average & sd
low_sp = lgt_find_index(10, f);
hig_sp = lgt_find_index(16, f);

avg = mean(max(P(:,low_sp:hig_sp),[],2));
sd = std(max(P(:,low_sp:hig_sp),[],2),0);


%% No spindle period analysis
rand_time = randi(length(Data),1,60);
rand_chan = randi(4,1,60);
for r = 1 : 60
    nepoch(r,:) = Data(rand_chan(r), rand_time(r):rand_time(r)+Fs-1);
end

% Get Powerspectrum of Spindles
[nP, f] = lgt_powerspectrum(nepoch,Fs,2,[],'abs');
max_hz = 30;
idx = lgt_find_index(max_hz, f);
% Get Relative Power
nP = nP(:,1:idx) ./ repmat(sum(nP(:,1:idx),2),[1,length(1:idx)]);


% Figure parameter
xlim1 = [1 400];
ylim1 = [-100 100];

xlim2 = [0 max_hz];
ylim2 = [0 0.5];

xtick1 = [1 200 400];
ytick1 = [-100 100];

xtick2 = [0 4 12 20 30];
ytick2 = [0 0.5];

f_range = 1:20;     % ~30 Hz


% Figure F3
i = 1;
figure;
for e = 1 : 15
    subplot(5,6,i);
    plot(nepoch(e,:)), xlim(xlim1); ylim(ylim1);
    set(gca, 'XTick', xtick1, 'YTick', ytick1, 'YDir', 'reverse');
    i = i + 1;
    
    subplot(5,6,i);
    plot(f(f_range), nP(e,f_range), 'r'); xlim(xlim2); ylim(ylim2)
    set(gca, 'Xtick', xtick2, 'YTick', ytick2);
    i = i + 1;
end

% Figure F4
i = 1;
figure;
for e = 16 : 30
    subplot(5,6,i);
    plot(nepoch(e,:)), xlim(xlim1); ylim(ylim1);
    set(gca, 'XTick', ytick1, 'YTick', ytick1, 'YDir', 'reverse');
    i = i + 1;
    
    subplot(5,6,i);
    plot(f(f_range), nP(e,f_range), 'r'); xlim(xlim2); ylim(ylim2)
    set(gca, 'Xtick', xtick2, 'YTick', ytick2);
    i = i + 1;
end

% Figure C3
i = 1;
figure;
for e = 31 : 45
    subplot(5,6,i);
    plot(nepoch(e,:)), xlim(xlim1); ylim(ylim1);
    set(gca, 'XTick', ytick1, 'YTick', ytick1, 'YDir', 'reverse');
    i = i + 1;
    
    subplot(5,6,i);
    plot(f(f_range), nP(e,f_range), 'r'); xlim(xlim2); ylim(ylim2)
    set(gca, 'Xtick', xtick2, 'YTick', ytick2);
    i = i + 1;
end

% Figure C4
i = 1;
figure;
for e = 46 : 60
    subplot(5,6,i);
    plot(nepoch(e,:)), xlim(xlim1); ylim(ylim1);
    set(gca, 'XTick', ytick1, 'YTick', ytick1, 'YDir', 'reverse');
    i = i + 1;
    
    subplot(5,6,i);
    plot(f(f_range), nP(e,f_range), 'r'); xlim(xlim2); ylim(ylim2)
    set(gca, 'Xtick', xtick2, 'YTick', ytick2);
    i = i + 1;
end



% 10~16 Hz Peak Value average & sd
low_sp = lgt_find_index(10, f);
hig_sp = lgt_find_index(16, f);

navg = mean(max(nP(:,low_sp:hig_sp),[],2));
nsd = std(max(nP(:,low_sp:hig_sp),[],2),0);





[H,Pval] = ttest(max(P(:,low_sp:hig_sp),[],2), max(nP(:,low_sp:hig_sp),[],2));