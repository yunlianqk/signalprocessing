%
% pr3_15_5  
clear all; clc; close all;

fs=250;                      % 采样频率
ast=15; ap=3;                % 阻带衰减和通带波纹
fst1=1; fst2=12;             % 阻带频率
fp1=1.5; fp2=10;             % 通带频率
% 笫1部分计算参数集合d
d=fdesign.bandpass('fst1,fp1,fp2,fst2,ast1,ap,ast2',fst1,fp1,fp2,fst2,ast,ap,ast,fs);
designmethods(d)             % 给出参数集合适用的滤波器
hd = design(d,'butter');     % 设计巴特沃斯滤波器
fvtool(hd);                  % 作图
set(gcf,'color','w')

% 第2部分,求直接型滤波器系数,并计算出分母的极点
[B,A]=tf(hd);
poles=roots(A);
M=length(poles);
for k=1 : M
    fprintf('%4d     %5.4f     %5.4fi     %5.4f\n',k,real(poles(k)),imag(poles(k)),abs(poles(k)));
end


