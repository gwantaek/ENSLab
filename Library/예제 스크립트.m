%% lgt_pow_spect 함수 예제 파일
%   2011.03.03
%   Lee Gwan-Taek

%%
clear all;
close all;

fa = 20;
fb = 30;
a = 5;
b = 10;

Fs = 256;                    % Sampling frequency
T = 1/Fs;                     % Sample time
L = 256;                     % Length of signal
t = (0:L-1)*T;                % Time vector
X(1,:) = a*sin(2*pi*fa*t);
X(2,:) = b*sin(2*pi*fb*t);

figure;plot(X(1,:));    % 5Hz의 amp가 5인 신호
figure;plot(X(2,:));    % 10Hz의 amp가 10인 신호

% 함수 사용법
% X : 데이터 매트릭스
% Fs : sampling rate
% 2 : time column dimension
% [] : epoch or trial column dimension
%      이곳을 [] 로 해놓으면 mean이 안됨.
%      epoch이 있는 데이터라면 해당 epoch의 dimension을 입력
%      리턴되는 P는 epoch 축으로 mean 되었기 때문에 전체 column의 수가
%      하나 감소. 즉 2x100x50 인 데이터에 이 파라메터를 3 으로 입력시
%      리턴되는 P 는 2x100 매트릭스가 됨.
% 'absolute' : 파워의 절대 값 혹은 상대 값  'absolute' or 'relative' 로 입력

% lgt_find_index 함수는 계산 되는 P는 전체 sampling rate의 2/5 Hz 까지 계산되는데
% 이중 plot시 필요한 부분만 보기 위해 사용.
% 60 : cut frequency
% f : lgt_pow_spect에서 P와 함께 리턴된 f 를 입력
% plot 할때 plot(f(1:idx),P(1:idx)) 와 같은 식으로 사용

% 밑의 코드는 2x256 데이터에서 average하지 않은상태의
% 각 row를 따로 power spectrum으로 출력
[P f] = lgt_power_spect(X,Fs,2,[],'abs');
idx = lgt_find_index(60,f);
figure;plot(f(1:idx),P(1,1:idx));
figure;plot(f(1:idx),P(2,1:idx));
% 
% % 밑의 코드는 2x256 데이터에서 첫번째 축 방향으로 average 한 후
% % power spectrum으로 출력, average 되었기 때문에, 하나만 출력됨.
[P f] = lgt_power_spect(X,Fs,2,1,'abs');
idx = lgt_find_index(60,f);
figure;plot(f(1:idx),P(1:idx));

%%
clear all;
close all;

fa = 20;
fb = 30;
a = 5;
b = 10;

Fs = 512;                    % Sampling frequency
T = 1/Fs;                     % Sample time
L = 1000;                     % Length of signal
t = (0:L-1)*T;                % Time vector
x1 = a*sin(2*pi*fa*t);
x2 = b*sin(2*pi*fb*t);
X = x1 + x2;

figure;plot(X);   % 20 Hz의 5 amp인 신호와 30 Hz의 10 amp인 두 신호의 합

% 위에서 만든 신호의 절대값 파워 출력
[P f] = lgt_power_spect(X,Fs,2,[],'abs');
idx = lgt_find_index(60,f);
figure;plot(f(1:idx),P(1:idx));

% 위에서 만든 신호의 상대값 파워 출력
% 5^2 + 10^2 = 125, 총 125의 파워에서 각각의 파워는 25와 100 이기 때문에
% 상대 값은 0.2와 0.8 이 됨
[P f] = lgt_power_spect(X,Fs,2,[],'rel');
idx = lgt_find_index(60,f);
figure;plot(f(1:idx),P(1:idx));


%% power spectrum fig 함수 사용법
clear all;
close all;

fa = 20;
fb = 30;
a = 5;
b = 10;

Fs = 512;                    % Sampling frequency
T = 1/Fs;                     % Sample time
L = 1000;                     % Length of signal
t = (0:L-1)*T;                % Time vector
x1 = a*sin(2*pi*fa*t);
x2 = b*sin(2*pi*fb*t);
X = x1 + x2;

% X : data
% Fs : sampling rate
% [0 100] : frequency range
% 2 : time dimension
% 1 : epoch dimension
% 'abs' : 'abs' or 'rel'
% 0 : 0 or 1 (decibel)
fig_power_spect(X,Fs,[0 100],2,1,'abs',0);


%% Coherence 함수 사용법

clear all;
close all;

fx = 50;
fy = 25;
ax = 10;
ay = 10;

Fs = 512;                    % Sampling frequency
T = 1/Fs;                     % Sample time
L = 1000;                     % Length of signal
t = (0:L-1)*T;                % Time vector
X = ax*sin(2*pi*fx*t);
Y = ay*sin(2*pi*fy*t);


t_dim = 2;
e_dim = 1;

[R f] = lgt_cross_spect(X,Y,Fs,t_dim,e_dim);
idx = lgt_find_index(60,f);
figure;plot(f(1:idx),R(1:idx));
