%
% pr8_2_3 
clear all; clc; close all;

Fs=1000;                           % 采样频率
N=1000;                            % 数据长度
n=1:N;                             % 索引号
t=(n-1)/Fs;                        % 时间序列
randn('state',0);                  % 随机数发生器初始化
f1=50; f2=120;                     % 两个正弦分量频率
x=cos(2*pi*f1*t)+3*cos(2*pi*f2*t)+randn(size(t)); % 信号
    
% 周期图法
window=boxcar(N);                  % 窗函数
nfft=1000;                         % FFT长
[Pxx1,f]=periodogram(x,window,nfft,Fs); % 周期图
sqrt(sum(Pxx1)*Fs/nfft)            % 计算周期图法平均能量

% welch法
Nfft=128;
window=boxcar(Nfft);               % 选用的窗口
noverlap=100;                      % 分段序列重叠的采样点数（长度）
range='onesided';                  % 单边谱
[Pxx2,freq]=pwelch(x,window,noverlap,Nfft,Fs,range);  %采用Welch方法估计功率谱
plot_Pxx=10*log10(Pxx2);
sqrt(sum(Pxx2)*Fs/Nfft)            % 计算welch法平均能量

% 作图
plot(f,10*log10(Pxx1),'r');        % 画对数刻度图
hold on; axis([0 500 -50 10]);     
xlabel('频率/Hz');
ylabel('功率谱密度/(dB/Hz)');
plot(freq,plot_Pxx,'k'); 
title('周期图法与welch法比较');
legend('周期图法','welch法')
set(gcf,'color','w');

