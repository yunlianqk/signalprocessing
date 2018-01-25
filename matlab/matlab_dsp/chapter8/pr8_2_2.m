%
% pr8_2_2 
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
sqrt(sum(Pxx1)*Fs/nfft)             % 计算周期图法平均能量
    
% 相关图法
nfft=1000;                         % FFT长
cxn=xcorr(x,500,'biased');         % 求有偏自相关函数，延迟只有N/2
cxn=cxn(1:nfft).*bartlett(nfft)';  % 乘以bartlett窗函数
CXk=fft(cxn,nfft)/Fs;              % 计算功率谱密度
Pxx2=abs(CXk);                     % 取幅值
ind=1:nfft/2;                      % 索引取一半,为取正频率部分
freq=(0:nfft-1)*Fs/nfft;           % 频率刻度
plot_Pxx=Pxx2(ind);                % 取正频率部分
plot_Pxx(2:end)=plot_Pxx(2:end)*2; % 单边谱,把2->nfft/2这部分幅值乘2
sqrt(sum(Pxx2)*Fs/nfft)             % 计算自相关法平均能量

% 作图
plot(f,10*log10(Pxx1),'r');        % 画对数刻度图
hold on; axis([0 500 -50 10]);     
xlabel('频率/Hz');
ylabel('功率谱密度/(dB/Hz)');
plot(freq(ind),10*log10(plot_Pxx),'k'); % 作功率谱图
title('周期图法与相关图法比较');
legend('周期图法','自相关图法')
set(gcf,'color','w');

