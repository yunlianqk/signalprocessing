%
% pr2_2_12 
clear all; clc; close all;

fs=200;                            % 采样频率
f1=30; f2=65.5;                    % 两信号频率
N=200;                             % 信号长度
n=1:N;                             % 样点索引
t=(n-1)/fs;                        % 时间刻度
x=cos(2*pi*f1*t)+cos(2*pi*f2*t);   % 信号

X1=fft(x);                         % 按N点进行FFT
freq1=(0:N/2)*fs/N;                % N点时正频率刻度
X1_abs=abs(X1(1:N/2+1))*2/N;       % 信号幅值

L=2*N;                             % 补零后FFT长度
X2=fft(x,L);                       % 按L长进行FFT
freq2=(0:L/2)*fs/L;                % L点时频率刻度
X2_abs=abs(X2(1:L/2+1))*2/N;       % 信号幅值
% 作图
subplot 211; plot(freq1,X1_abs,'k'); 
grid; ylim([0 1.2]);
xlabel('频率/Hz'); ylabel('幅值');
title('(a) 补零前FFT谱图')
subplot 212; plot(freq2,X2_abs,'k');
grid; ylim([0 1.2]);
xlabel('频率/Hz'); ylabel('幅值');
title('(b) 补零后FFT谱图')
set(gcf,'color','w');
