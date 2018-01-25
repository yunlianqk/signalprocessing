%
% pr2_2_16 
clear all; clc; close all;

xx=load('delaydata3.txt');% 读入数据
x=xx(:,1);               % 设为x
y=xx(:,2);               % 设为y
N=length(x);             % 数据长度
fs=1000;                 % 采样频率
Xc=fft(x);               % FFT
Yc=fft(y);               % FFT
Scxy=Yc.*conj(Xc);       % 计算循环相关
scxy=ifftshift(ifft(Scxy));
Ccxy=scxy(2:end);        % 循环相关函数
lagc=-N/2+1:N/2-1;       % 延迟量刻度
% 作图
subplot 211; plot(lagc,Ccxy,'k'); 
title('(a) x和y的循环相关');
xlabel('样点'); ylabel('相关函数幅值')

[Rxy,lags]=xcorr(y,x);   % 计算线性相关
% 作图
subplot 212; plot(lags,Rxy,'k');
title('(b) x和y的线性相关')
xlabel('样点'); ylabel('相关函数幅值')
set(gcf,'color','w')

