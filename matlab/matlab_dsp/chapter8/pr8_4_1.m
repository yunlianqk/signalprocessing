% 
% pr8_4_1 
clear all; clc; close all;

randn('state',0);                    % 随机数初始化
Fs = 1000;                           % 采样频率
t = 0:1/Fs:1-1/Fs;                   % 时间刻度
f1=50; f2=120;                       % 两个正弦分量频率
x=cos(2*pi*f1*t)+3*cos(2*pi*f2*t)+randn(size(t)); % 信号
N = length(x);                       % x长度
% 调用periodogram函数
[Pxx,f]=periodogram(x,rectwin(length(x)),N,Fs);

% 调用spectrum.periodogram和psd函数
Hd=spectrum.periodogram('Rectangular');
Ps=psd(Hd,x,'Fs',Fs,'NFFT',N);
% 取来功率谱密度和频率参数
Pxx1=Ps.data;
f1=Ps.frequencies;
% 作图
subplot 211
plot(f,10*log10(Pxx),'k');           % 取对数作图
grid on; xlim([0 Fs/2]);
title('调用periodogram函数的周期图')
xlabel('频率/Hz')
ylabel('功率谱密度/(dB/Hz)')
subplot 212
plot(f1,10*log10(Pxx1),'k');          % 取对数作图
grid on; xlim([0 Fs/2]);
title('调用spectrum.periodogram函数的周期图')
xlabel('频率/Hz')
ylabel('功率谱密度/(dB/Hz)')
mxerr = max(Pxx-Pxx1)                 % 求两种方法的最大差值
set(gcf,'color','w'); 
