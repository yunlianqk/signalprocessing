%
% pr5_1_6 
clear all; clc; close all;

N=1024;                      % 数据长度
fs=1000;                     % 采样频率
tt=(0:N-1)/fs;               % 时间刻度
x=chirp(tt,100,1,250);       % Chirp 信号x
wlen=128;                    % 帧长
wind=hanning(wlen);          % 窗函数
noverlap=wlen-1;             % 重叠部分长度
% 没进行延拓,做STFT频谱
[B,freq,time]=spectrogram(x,wind,noverlap,wlen,fs);
% 数据延拓
L=wlen/2;                    % 延拓长度
p=10;                        % 阶数
y=forback_predictm(x,L,p);   % 前后向延拓
% 进行延拓后做STFT频谱
[B1,freq,time1]=spectrogram(y,wind,noverlap,wlen,fs);
tt1=(0:N)/fs;                % 延拓后STFT频谱的时间刻度
% 作图
figure(1)
plot(tt,x,'k'); xlim([0 max(tt)]);
xlabel('时间/s'); ylabel('幅值');
title('调频信号波形图')
set(gcf,'color','w');
figure(2)
subplot 211; imagesc(time,freq,abs(B)); axis xy;
xlabel('时间/s'); ylabel('频率/Hz');
title('没延拓STFT谱图'); ylim([50 350]);
subplot 212; imagesc(tt1,freq,abs(B1)); axis xy;
xlabel('时间/s'); ylabel('频率/Hz');
title('延拓后STFT谱图'); ylim([50 350]);
set(gcf,'color','w');
