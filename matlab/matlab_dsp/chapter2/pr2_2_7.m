%
% pr2_2_7 
clear all; clc; close all

[x,fs]=wavread('sndwav1.wav');  % 读入数据
N=length(x);                    % 数据个数
time=(0:N-1)/fs;                % 时间刻度
p0=2e-5;                        % 参考声压
nfft=2^nextpow2(N);             % 把FFT的个数扩展为2的整数次幂
n2=1:nfft/2+1;                  % 正频率的索引号
X = fft(x,nfft);                % FFT
freq = (0:nfft/2)*fs/nfft;      % 计算频率刻度
X_abs=abs(X(n2))*2/N;           % 计算幅值
X_level=20*log10(X_abs/p0);     % 计算声压级
% 作图
subplot(211);
plot(time,x,'k');
xlabel('时间/s'); ylabel('幅值/pa')
title('信号的波形图')
subplot 212; plot(freq/1000,X_level,'k');
xlabel('频率/kHz'); ylabel('声压级/dB')
title('信号的声压级谱图'); axis([0 24 -35 35]);

