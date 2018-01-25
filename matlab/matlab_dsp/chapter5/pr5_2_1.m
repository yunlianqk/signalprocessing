%
% pr5_2_1 
clear all; clc; close all;

N=640;                       % 数据长度 
fs=200;                      % 采样频率
t=(0:N-1)/fs;                % 时间刻度
% 构成信号序列
x=10*sin(2*pi*32*t)+10*sin(2*pi*50*t)+20*sin(2*pi*54*t)+...
    20*sin(2*pi*56*t)+30*sin(2*pi*59*t)+20*sin(2*pi*83*t);

nfft=64;                     % FFT长度
X=fft(x,nfft);               % FFT分析
ff=(0:(nfft/2-1))*fs/nfft;   % 频率刻度
n2=1:nfft/2;                 % 正频率索引号
X_abs=abs(X(n2))*2/nfft;     % 正频率部分的幅值谱
fe=55;                       % 中心频率
D=10;                        % 细化倍数
[y,freq]=exzfft_ma(x,fe,fs,nfft,D);  % 细化分析
% 作图
figure(1)
subplot 311; plot(t,x,'k');
xlabel('时间/s'); ylabel('幅值');
xlim([0 1]); title('时间序列');
subplot 312; plot(ff,X_abs,'k');
xlabel('频率/Hz'); ylabel('幅值');
title('细化分析前频谱'); grid;
subplot 313; plot(freq,abs(y),'k'); grid;
set(gca, 'XTickMode', 'manual', 'XTick', [50,54,56,59]);
set(gca, 'YTickMode', 'manual', 'YTick', [10,20,30]);
xlabel('频率/Hz'); ylabel('幅值');
title('细化分析的频谱');
set(gcf,'color','w');
figure(2)
plot(ff,X_abs,'k--');  hold on
xlabel('频率/Hz'); ylabel('幅值');
plot(freq,abs(y),'k'); grid; ylim([0 32]);
legend('细化分析前的频谱','细化分析的频',2)
title('细化分析前的频谱与细化分析频谱的对照');
set(gca, 'XTickMode', 'manual', 'XTick', [32,50,54,56,59,83]);
set(gca, 'YTickMode', 'manual', 'YTick', [10,20,30]);
set(gcf,'color','w');
