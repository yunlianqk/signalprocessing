%
% pr10_5_2 
clear all; clc; close all;

Fs=8000;                                  % 采样频率
Fs2=Fs/2;

fp=60; fs=20;                             % 通带波纹和阻带频率
wp=fp/Fs2; ws=fs/Fs2;                     % 转换成归一化频率
Rp=1; Rs=40;                              % 通带和阻带衰减
[n,Wn]=cheb2ord(wp,ws,Rp,Rs);             % 计算滤波器阶次

[b1,a1]=cheby2(n,Rs,Wn,'high');           % 计算滤波器系数
fprintf('b=%5.6f   %5.6f   %5.6f   %5.6f   %5.6f\n',b1);
fprintf('a=%5.6f   %5.6f   %5.6f   %5.6f   %5.6f\n',a1);
fprintf('\n');
[db,mag,pha,grd,w]=freqz_m(b1,a1);        % 求出滤波器频率响应
a=[1 -0.99];
db1=freqz_m(1,a);                         % 计算低通滤波器频率响应  
A=conv(a,a1);                             % 计算串接滤波器系数
B=b1;
db2=freqz_m(B,A);
fprintf('B=%5.6f   %5.6f   %5.6f   %5.6f   %5.6f\n',B);
fprintf('A=%5.6f   %5.6f   %5.6f   %5.6f   %5.6f   %5.6f\n',A);
% 作图
pos = get(gcf,'Position');
set(gcf,'Position',[pos(1), pos(2)-100,pos(3),pos(4)+100]);
subplot 221; plot(w/pi*Fs2,db1,'k'); 
title('低通滤波器幅值频率响应曲线')
ylim([-50 0]); ylabel('幅值/dB'); xlabel(['频率/Hz' 10 '(a)']);
subplot 222; plot(w/pi*Fs2,db,'k');
title('高通滤波器幅值频率响应曲线')
axis([0 500 -50 5]); ylabel('幅值/dB'); xlabel(['频率/Hz' 10 '(b)']);
subplot 212; semilogx(w/pi*Fs2,db2,'k');
title('带通滤波器幅值频率响应曲线'); ylabel('幅值/dB'); 
xlabel(['频率/Hz' 10 '(c)']); axis([10 3500 -40 5]); grid




