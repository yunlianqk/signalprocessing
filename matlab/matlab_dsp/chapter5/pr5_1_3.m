%
% pr5_1_3 
clear all; clc; close all;

[x,fs,bits] = wavread('shortsd.wav');  % 读入信号
N=length(x);                           % 信号长度
tt=(0:N-1)/fs;                         % 时间刻度

h=hanning(63);                         % 窗长63
[B1,t,f1]=tfrstft(x,1:N,64,h);         % Nfft=64
[B2,t,f2]=tfrstft(x,1:N,1024,h);       % Nfft=1024
% 作图
subplot 211; imagesc(tt,f1(1:32)*fs,abs(B1(1:32,:))); axis xy
xlabel('时间/s'); ylabel('频率/Hz');
title('Nfft=64');
subplot 212; imagesc(tt,f2(1:512)*fs,abs(B2(1:512,:))); axis xy
xlabel('时间/s'); ylabel('频率/Hz');
title('Nfft=1024');
set(gcf,'color','w');


