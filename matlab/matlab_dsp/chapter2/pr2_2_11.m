%
% pr2_2_11  
clear all; clc; close all;

f1=50; a1=311.46;                        % 设置第1个分量的频率与幅值
f2=46; a2=1.57;                          % 设置第2个分量的频率与幅值
N=12000;                                 % 设置数据长度N
fs=8000;                                 % 设置采样频率fs
t=(0:N-1)/fs;                            % 设置时间刻度
x=a1*cos(2*pi*f1*t)+a2*cos(2*pi*f2*t);   % 设置信号
freq=(0:N/2)*fs/N;                       % 设置频率刻度
wind=blackman(N)';                       % 给出布莱克曼窗函数
X=fft(x.*wind);                          % FFT
plot(freq,20*log10(abs(X(1:N/2+1))),'k');% 作图
grid; xlim([0 100])
xlabel('频率/Hz'); ylabel('幅值/dB');
title('信号谱图');
set(gcf,'color','w');

