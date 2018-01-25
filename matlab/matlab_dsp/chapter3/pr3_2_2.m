%
% pr3_2_2 
clear all; close all; clc;

wp=0.2*pi;                       % 设置通带频率
ws=0.3*pi;                       % 设置阻带频率
Rp=3; Rs=20;                     % 设置波纹系数

[N,Wn]=buttord(wp,ws,Rp,Rs,'s'); % 求巴特沃斯滤波器阶数
[bn,an]=butter(N,Wn,'s');        % 求巴特沃斯滤波器系数
fprintf('巴特沃斯滤波器 N=%4d\n',N) % 显示滤波器阶数
% 显示系数
fprintf('%5.6e   %5.6e   %5.6e   %5.6e   %5.6e   %5.6e   %5.6e\n',bn);
fprintf('%5.6e   %5.6e   %5.6e   %5.6e   %5.6e   %5.6e   %5.6e\n',an);

[z,p,k]=buttap(N);               % 设计低通原型数字滤波器
[Bap,Aap]=zp2tf(z,p,k);          % 零点极点增益形式转换为传递函数形式
[bb,ab]=lp2lp(Bap,Aap,Wn);       % 低通滤波器频率转换
% 显示系数
fprintf('%5.6e\n',bb);
fprintf('%5.6e   %5.6e   %5.6e   %5.6e   %5.6e   %5.6e   %5.6e\n',ab);
