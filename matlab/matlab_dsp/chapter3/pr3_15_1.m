%
% pr3_15_1 
clear all; clc; close all;

d = fdesign.lowpass('N,F3dB,ap',6,0.4,0.5);  % 设置滤波器的参数集合
designmethods (d)         % 给出参数集合适用的滤波器
hd = design(d,'cheby1');  % 设计契比雪夫I型滤波器
fvtool(hd)                % 显示滤波器响应曲线


