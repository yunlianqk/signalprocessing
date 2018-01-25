% 
% pr3_7_7 
clear all; clc; close all;

K=1.74802;                           % K(r)中的参数值 
w1=2*pi*9.15494;
w2=2*pi*2.27979;
w3=2*pi*1.22535;
w4=2*pi*21.9;
lemda=2*pi*4.05981;
Fs=400;                              % 采样频率
% 把K(r)中的各参数值转为2个子系统的系数
b(1)=K*w1; b(2)=0;                   % 第1子系统分子
a(1)=1/w2; a(2)=1;                   % 第2子系统分子
c(1)=1; c(2)=2*lemda; c(3)=w1*w1;    % 第1子系统分母
d(1)=1/w3/w4; d(2)=1/w3+1/w4; d(3)=1;% 第1子系统分母

B=conv(b,a);                         % 求出模拟系统的分子的系数
A=conv(c,d);                         % 求出模拟系统的分母的系数
[Hs,whs]=freqs(B,A);                 % 求模拟系统响应曲线

[num,den]=bilinear(B,A,Fs);          % 双线性Z变换求出数字系统的分子和分母系数
[Hz,wz]=freqz(num,den);              % 求数字系统响应曲线
% 作图
plot(whs/2/pi,abs(Hs),'k:','linewidth',2)
axis([0 30  0 1.2]); box on; hold on
plot(wz/pi*Fs/2,abs(Hz),'k','linewidth',2);
title('K(s)模拟响应曲线和数字响应曲线比较');
xlabel('频率/Hz'); ylabel('幅值')
legend('模拟系统','数字系统');
set(gcf,'color','w');

