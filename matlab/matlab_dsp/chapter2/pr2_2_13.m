%
% pr2_2_13 
clear all; clc; close all;

M=10; fs=10;                                    % 设置数据长度M和采样频率fs
f1=1; f2=2.5; f3=3;                             % 设置3个正弦信号的频率
t=(0:M-1)/fs;                                   % 设置时间序列
x=cos(2*pi*f1*t)+cos(2*pi*f2*t)+cos(2*pi*f3*t); % 计算出信号波形

X1=fft(x);                                      % FFT变换
freq1=(0:5)*fs/10;                              % 计算3个信号在频域的频率刻度
X2=fft(x,40);                                   % FFT变换
freq2=(0:20)*fs/40;                             % 计算3个信号在频域的频率刻度
% 作图
plot(freq1,abs(X1(1:6)),'k-.',freq2,abs(X2(1:21)),'k');
title('补零后DFT变换');
xlabel('频率/Hz'); ylabel('幅值');
legend('FFT变换长为10','FFT变换长为40')
set(gcf,'color','w');

