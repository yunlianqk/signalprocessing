%
% pr3_7_6  
clear all; clc; close all;

fp=[100 200]; fs=[50 250];       % 设置数字滤波器的通带和阻带
Fs=1000;                         % 采样频率
Rp=2; Rs=40;                     % 设置通带的波纹和阻带的衰减
wp=2*fp*pi; ws=2*fs*pi;          % 把通带和阻带换算成角频率
[N,Wn]=cheb2ord(wp,ws,Rp,Rs,'s');% 计算模拟滤波器的阶数和带宽
[Bs,As]=cheby2(N,Rs,Wn,'s');     % 计算模拟滤波器系数
[Hs,w]=freqs(Bs,As);             % 计算模拟滤波器的响应曲线
[Bz,Az]=bilinear(Bs,As,1000);    % 通过双线性Z变换转换成数字滤波器系数
[Hz,fz]=freqz(Bz,Az,1000,Fs);    % 计算数字滤波器的响应曲线
% 作图
line(w/2/pi,20*log10(abs(Hs)),'color',[.6 .6 .6],'linewidth',3);
grid; axis([0 500 -60 5]); hold on
plot(fz,20*log10(abs(Hz)),'k');
legend('模拟滤波器','数字滤波器')
xlabel('频率/Hz'); ylabel('幅值/dB');
title('不进行预畸的数字滤波器与模拟滤波器响应曲线比较')
set(gcf,'color','w'); box on
 

