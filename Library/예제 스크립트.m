%% lgt_pow_spect �Լ� ���� ����
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

figure;plot(X(1,:));    % 5Hz�� amp�� 5�� ��ȣ
figure;plot(X(2,:));    % 10Hz�� amp�� 10�� ��ȣ

% �Լ� ����
% X : ������ ��Ʈ����
% Fs : sampling rate
% 2 : time column dimension
% [] : epoch or trial column dimension
%      �̰��� [] �� �س����� mean�� �ȵ�.
%      epoch�� �ִ� �����Ͷ�� �ش� epoch�� dimension�� �Է�
%      ���ϵǴ� P�� epoch ������ mean �Ǿ��� ������ ��ü column�� ����
%      �ϳ� ����. �� 2x100x50 �� �����Ϳ� �� �Ķ���͸� 3 ���� �Է½�
%      ���ϵǴ� P �� 2x100 ��Ʈ������ ��.
% 'absolute' : �Ŀ��� ���� �� Ȥ�� ��� ��  'absolute' or 'relative' �� �Է�

% lgt_find_index �Լ��� ��� �Ǵ� P�� ��ü sampling rate�� 2/5 Hz ���� ���Ǵµ�
% ���� plot�� �ʿ��� �κи� ���� ���� ���.
% 60 : cut frequency
% f : lgt_pow_spect���� P�� �Բ� ���ϵ� f �� �Է�
% plot �Ҷ� plot(f(1:idx),P(1:idx)) �� ���� ������ ���

% ���� �ڵ�� 2x256 �����Ϳ��� average���� ����������
% �� row�� ���� power spectrum���� ���
[P f] = lgt_power_spect(X,Fs,2,[],'abs');
idx = lgt_find_index(60,f);
figure;plot(f(1:idx),P(1,1:idx));
figure;plot(f(1:idx),P(2,1:idx));
% 
% % ���� �ڵ�� 2x256 �����Ϳ��� ù��° �� �������� average �� ��
% % power spectrum���� ���, average �Ǿ��� ������, �ϳ��� ��µ�.
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

figure;plot(X);   % 20 Hz�� 5 amp�� ��ȣ�� 30 Hz�� 10 amp�� �� ��ȣ�� ��

% ������ ���� ��ȣ�� ���밪 �Ŀ� ���
[P f] = lgt_power_spect(X,Fs,2,[],'abs');
idx = lgt_find_index(60,f);
figure;plot(f(1:idx),P(1:idx));

% ������ ���� ��ȣ�� ��밪 �Ŀ� ���
% 5^2 + 10^2 = 125, �� 125�� �Ŀ����� ������ �Ŀ��� 25�� 100 �̱� ������
% ��� ���� 0.2�� 0.8 �� ��
[P f] = lgt_power_spect(X,Fs,2,[],'rel');
idx = lgt_find_index(60,f);
figure;plot(f(1:idx),P(1:idx));


%% power spectrum fig �Լ� ����
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


%% Coherence �Լ� ����

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
