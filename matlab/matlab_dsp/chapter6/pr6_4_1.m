%
%  pr6_4_1 
clear all; clc; close all;
fs = 1024;                   % 采样频率
N  = 1024;                   % 数据长

arc=pi/180;                  % 1弧度
n1=1:N;                      % 第1次取数值范围
n2=1:N;                      % 数据长
t2=(n2-1)/fs;                % 时间刻度

Am=[3.3 5.4 8.7 2.6];        % 幅值参数
Fr=[42.7 196.3 250.4 354.8]; % 频率参数(Hz)
Theta=[30 50 80 140];        % 初始相位参数(度)
x=zeros(1,N);                % 数据初始化
% 产生信号
for k=1 : 4
    x=x+Am(k)*cos(2*pi*Fr(k)*t2+Theta(k)*arc);  % 信号
end
L=128; M=N/2;               % L和M
Z=Phase_Gmtda(x,N,L,M,fs,40,45,2); % 检测第1个分量
fprintf('%5.6f  %5.6f  %5.6f\n',Z(1),Z(2),Z(3)/arc);

Z=Phase_Gmtda(x,N,L,M,fs,190,200,2); % 检测第2个分量
fprintf('%5.6f  %5.6f  %5.6f\n',Z(1),Z(2),Z(3)/arc);

Z=Phase_Gmtda(x,N,L,M,fs,245,255,2); % 检测第3个分量
fprintf('%5.6f  %5.6f  %5.6f\n',Z(1),Z(2),Z(3)/arc);

Z=Phase_Gmtda(x,N,L,M,fs,350,360,2); % 检测第4个分量
fprintf('%5.6f  %5.6f  %5.6f\n',Z(1),Z(2),Z(3)/arc);






