%
% pr6_4_3 
clear all; clc; close all;

fs = 1024;                             % 采样频率
N  = 40960;                            % 数据长
n1=1:1:N;                              % 第1次取数值范围
t2=(n1-1)/fs;                          % 时间刻度
arc=pi/180;                            % 1弧度

Am=[0.15 10 0.11];                     % 幅值参数
Fr=[48.08 49.72 51.36];                % 频率参数
Theta=[73 32 -13];                     % 初始相位参数(度)
x=zeros(1,N);                          % 数据初始化
% 产生信号
for k=1 : 3
    x=x+Am(k)*cos(2*pi*Fr(k)*t2+Theta(k)*arc);  % 信号
end
% ZFFT
D=128; fe=50;                          % 细化倍数和中心频率
nfft=256;                              % nfft长
[y,freq,xx]=exzfft_ma(x,fe,fs,nfft,D); % ZFFT 

% 校正分析
fs1=fs/D;                              % 降采样后的采样频率
fi=freq(1);                            % 频率刻度第1点的值
Nw=256; Lw=32;                         % 设置L和M
% 按时域平移相位差校正法计算
Z=phase1_afterexzfft(xx,fi,Nw,Lw,fs1,47.5,49); % 检测第1个分量
fprintf('%5.6f   %5.6f   %5.6f\n',Z(1),Z(2),Z(3)/arc)
Z=phase1_afterexzfft(xx,fi,Nw,Lw,fs1,49,50.5); % 检测第2个分量
fprintf('%5.6f   %5.6f   %5.6f\n',Z(1),Z(2),Z(3)/arc)
Z=phase1_afterexzfft(xx,fi,Nw,Lw,fs1,50.5,52); % 检测第3个分量
fprintf('%5.6f   %5.6f   %5.6f\n',Z(1),Z(2),Z(3)/arc)



