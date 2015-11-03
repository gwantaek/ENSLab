clear all;
close all;

fa = 5;
a = 5;

Fs = 256;                    % Sampling frequency
T = 1/Fs;                     % Sample time
L = 256;                     % Length of signal
t = (0:L-1)*T;                % Time vector
data = a*sin(2*pi*fa*t);

%%
Fs = 200;
data = data(1,:);

figure;plot(data);    % 5Hz의 amp가 5인 신호
figure;fig_powerspectrum(data,Fs,[1 50],2,1,'abs',1);

srrg = lgt_getsurrogate(data,1);
figure;plot(srrg);
figure;fig_powerspectrum(srrg,Fs,[1 50],1,2,'abs',1);