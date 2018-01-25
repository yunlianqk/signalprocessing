%
% pr2_2_14 
clear all; clc; close all;

N=256;                         % 窗长度             
x=boxcar(N);                   % 设置矩形窗
% 第一部分
X1=fft(x);                     % FFT
X1_abs=abs(fftshift(X1));      % 计算幅值
freq1=(-128:127)/N;            % 频率刻度1
subplot 311; plot(freq1,X1_abs,'k');      % 作图
xlim([-0.1 0.1]);
xlabel('归一化频率'); ylabel('幅值');
title('(a) 补零前FFT谱图')
% 第二部分
X2=fft(x,N*8);                 % 对矩形窗补零后FFT
X2_abs=abs(fftshift(X2));      % 计算幅值
freq2=(-N*4:N*4-1)/(N*8);      % 频率刻度2
subplot 312; plot(freq2,X2_abs,'k');      % 作图
xlim([-0.1 0.1]);
xlabel('归一化频率'); ylabel('幅值');
title('(b) 补零后FFT谱图')
X2_dB=20*log10(X2_abs/(max(X2_abs))+eps); % 幅值取分贝值
subplot 313; plot(freq2,X2_dB,'k');       % 作图
axis([0 0.1 -50 5]);
xlabel('归一化频率'); ylabel('幅值/dB');
title('(c) 补零后FFT谱图-分贝值')
set(gcf,'color','w');

