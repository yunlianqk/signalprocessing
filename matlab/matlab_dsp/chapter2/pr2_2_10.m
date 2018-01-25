%
% pr2_2_10  
clear all; clc; close all;

M=256; fs=10;                                   % 设置数据长度M和采样频率fs
f1=1; f2=2.5; f3=3;                             % 设置3个正弦信号的频率
t=(0:M-1)/fs;                                   % 设置时间序列
x=cos(2*pi*f1*t)+cos(2*pi*f2*t)+cos(2*pi*f3*t); % 计算出信号波形

X1=fft(x,20);                                   % FFT变换
X2=fft(x,40);
X3=fft(x,128);
freq1=(0:10)*fs/20;                              % 计算3个信号在频域的频率刻度
freq2=(0:20)*fs/40;
freq3=(0:64)*fs/128;
% 作图
plot(freq1,abs(X1(1:11)),'k',freq2,abs(X2(1:21)),'k',freq3,abs(X3(1:65)),'k');
%legend('N=20','N=40','N=128');
title('不同N值的DFT变换');
xlabel('频率/Hz'); ylabel('幅值');
set(gcf,'color','w');

