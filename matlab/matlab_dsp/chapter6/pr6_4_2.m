%
% pr6_4_2 
clear all; clc; close all;
fs = 1024;                  % 采样频率
N  = 4096;                  % 数据长

arc=pi/180;                 % 1弧度
ra=[131 137];               % 搜找范围
n1=1:1:N;                   % 第1次取数值范围
n2=1:2*N;                   % 数据长
t2=(n2-1)/fs;               % 时间刻度

Am=[0.15 10 0.11];           % 幅值参数
Fr=[48.08 49.72 51.36];      % 频率参数
Theta=[73 32 -13];           % 初始相位参数(度)
x=zeros(1,2*N);              % 数据初始化

% 产生信号
for k=1 : 3
    x=x+Am(k)*cos(2*pi*Fr(k)*t2+Theta(k)*arc);  % 信号
end
L=1024; M=N;               % 设置L和M
wind1=blackmanharris(N);   % Blackmanharris窗函数
wind2=blackmanharris(M);

Z=phase_AnyWind(x,N,L,M,fs,47,49,wind1,wind2); % 检测第1个分量
fprintf('%5.6f  %5.6f  %5.6f\n',Z(1),Z(2),Z(3)/arc);

Z=phase_AnyWind(x,N,L,M,fs,49,51,wind1,wind2); % 检测第2个分量
fprintf('%5.6f  %5.6f  %5.6f\n',Z(1),Z(2),Z(3)/arc);

Z=phase_AnyWind(x,N,L,M,fs,51,53,wind1,wind2); % 检测第3个分量
fprintf('%5.6f  %5.6f  %5.6f\n',Z(1),Z(2),Z(3)/arc);





