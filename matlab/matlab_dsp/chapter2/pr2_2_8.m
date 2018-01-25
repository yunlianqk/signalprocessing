%
% pr2_2_8 
clear all; clc; close all;

fs=128;                         % 采样频率
% 第一部分
N=128;                          % 信号长度
t=(0:N-1)/fs;                   % 时间序列
y=cos(2*pi*30*t);               % 余弦信号
Y=fft(y,N);                     % FFT
freq=(0:N/2)*fs/N;              % 按式(2-2-7)设置频率刻度
n2=1:N/2+1;                     % 计算正频率的索引号
Y_abs=abs(Y(n2))*2/N;           % 给出正频率部分的频谱幅值
% 作图
subplot 211; stem(freq,Y_abs,'k')
xlabel('频率(Hz)'); ylabel('幅值');
title('(a) Fs=128Hz, N=128')
axis([10 50 0 1.2]); 

% 第二部分
N1=100;                           % 信号长度
t1=(0:N1-1)/fs;                   % 时间序列
y1=cos(2*pi*30*t1);               % 余弦信号
Y1=fft(y1,N1);                    % FFT
freq1=(0:N1/2)*fs/N1;             % 按式(2-2-7)设置频率刻度
n2=1:N1/2+1;                      % 计算正频率的索引号
Y_abs1=abs(Y1(n2))*2/N1;          % 给出正频率部分的频谱幅值
% 作图
subplot 212; stem(freq1,Y_abs1,'k')
xlabel('频率(Hz)'); ylabel('幅值');
title('(b) Fs=128Hz, N=100')
axis([10 50 0 1.2]); hold on
line([30 30],[0 1],'color',[.6 .6 .6],'linestyle','--');
plot(30,1,'ko','linewidth',5)
set(gcf,'color','w');
