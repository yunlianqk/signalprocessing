%
% pr2_2_1 
clear all; clc; close all;

fs=128;                         % 采样频率
N=128;                          % 信号长度
t=(0:N-1)/fs;                   % 时间序列
y=cos(2*pi*30*t);               % 余弦信号
y=fft(y,N);                     % FFT
freq=(0:N/2)*fs/N;              % 按式(2-2-6c)设置正频率刻度 
% 作图
stem(freq,abs(y(1:N/2+1)),'k')
xlabel('频率(Hz)'); ylabel('幅值');
title('(b) 只有正频率刻度')
xlim([25 35]);
set(gcf,'color','w');

