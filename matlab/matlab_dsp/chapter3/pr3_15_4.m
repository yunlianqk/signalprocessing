%
% pr3_15_4  
clear all; clc; close all;

d = fdesign.lowpass('Fp,Fst,Ap,Ast',0.25,0.4,0.25,40);  % 设置滤波器的参数集合
designmethods (d)         % 给出参数集合适用的滤波器
hd = design(d,'alliir');  % 设计IIR滤波器
fvtool(hd)                % 作图
legend('巴特沃斯滤波器','契比雪夫I型滤波器','契比雪夫II型滤波器','椭圆滤波器')
set(gcf,'color','w')


