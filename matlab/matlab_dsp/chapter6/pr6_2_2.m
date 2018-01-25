%
% pr6_2_2 
close all; clear all; clc;
fs=1024;                     % 采样频率
N=1024;                      % 信号长度
rad=pi/180;                  % 1弧度
t=(0:N-1)/fs;                % 时间序列
f1=80; phy1=30.7; A1=4;      % 信号1参数
f2=150.232; phy2=75.2; A2=3; % 信号2参数
f3=253.5453; phy3=240; A3=1; % 信号3参数

x=A1*sin(2*pi*f1*t+phy1*rad)+A2*sin(2*pi*f2*t+phy2*rad)+...
    A3*cos(2*pi*f3*t+phy3*rad);
NXX=[75 85; 145 155; 250 260]; % 设置寻找最大值区间
% 寻找峰值并提取正弦信号的参数
for k=1 : 3
    NX=NXX(k,:);               % 获取搜寻的区间
    Z=specor_m1(x,fs,N,NX,2);  % 通过比值修正法提取信号参数
    fprintf('%4d   %5.4f   %5.4f   %5.4f   %5.4f\n',k,Z(1),Z(2),Z(3),Z(3)/rad); 
end
