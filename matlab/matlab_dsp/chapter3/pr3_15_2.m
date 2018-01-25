%
% pr3_15_2 
clear all; clc; close all;

d=fdesign.lowpass('Fp,Fst,Ap,Ast',0.25,0.4,0.25,40);  % 设置滤波器的参数集合
designmethods(d)                   % 给出参数集合适用的滤波器
hd=design(d,'ellip');              % 设计椭圆滤波器

[N,wn]=ellipord(0.25,0.4,0.25,40); % 以传统使用方法求滤波器的阶数和带宽
[b,a]=ellip(N,0.25,40,wn);         % 计算椭圆滤波器的系数
Hd=dfilt.df2(b,a);                 % 求出传统使用方法的滤波器系数集合
% 作图
fvtool(hd,Hd)
legend('fdesign+design法','传统使用方法');
set(gcf,'color','w')            
