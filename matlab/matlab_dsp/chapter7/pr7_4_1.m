% 
% pr7_4_1  
clear all; clc; close all;

f0=49.13;                    % 基波频率
fs=3200;                     % 采样频率
N=2048;                      % 数据长度
n=0:N-1;                     % 数据索引
rad=pi/180;                  % 角度和弧度的转换因子
xb=[240,0.1,12,0.1,2.7,0.05,2.1,0,0.3,0,0.6]; % 谐波幅值
Q=[0,10,20,30,40,50,60,0,80,0,100]*rad;       % 谐波初始相位

t=n/fs;
M=11;
x=zeros(1,N);                % 初始化
for k=1 : M                  % 产生谐波信号
    x=x+xb(k)*cos(2*pi*f0*k*t+Q(k));
end
% 调用signal_hpronys函数检测谐波参数
Z=signal_hpronys(x,30,fs,0.0001);
K=size(Z,1);                 % 获取谐波的个数
% 显示谐波参数
for k=1 : K
   fprintf('%4d     alpha=%5.6f   F=%5.6f  A=%5.6f  theta=%5.6f\n',...
       k,Z(k,1),Z(k,2),Z(k,3),Z(k,4)/rad);
end


