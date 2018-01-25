% 
% pr8_4_3 
clear all; clc; close all;

randn('state',0);                    % 随机数初始化
Fs = 1000;                           % 采样频率
t = 0:1/Fs:1-1/Fs;                   % 时间刻度
f1=50; f2=120;                       % 两个正弦分量频率
x=cos(2*pi*f1*t)+3*cos(2*pi*f2*t)+randn(size(t)); % 信号
nfft=1024;                           % FFT长度 
p=12;                                % AR模型阶数
% 调用burg函数
[Pxx1,freq1]=pburg(x,p,nfft,Fs);

% 调用spectrum.burg和psd函数
Hd=spectrum.burg(p);
Ps=psd(Hd,x,'Fs',Fs,'NFFT',nfft);
% 取来功率谱密度和频率数值
Pxx2=Ps.data;
freq2=Ps.frequencies;
% 作图
subplot 211
plot(freq1,10*log10(Pxx1),'k');      % 取对数作图
grid on; xlim([0 Fs/2]);
title('调用pburg函数的改进周期图')
xlabel('频率/Hz')
ylabel('功率谱密度/(dB/Hz)')
subplot 212
plot(freq2,10*log10(Pxx2),'k');      % 取对数作图
grid on; xlim([0 Fs/2]);
title('调用spectrum.burg函数的改进周期图')
xlabel('频率/Hz')
ylabel('功率谱密度/(dB/Hz)')
mxerr = max(Pxx1-Pxx2)                 % 求两种方法的最大差值
set(gcf,'color','w'); 
