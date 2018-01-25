% 
% pr7_4_3  
clear all; clc; close all;
warning off

f=[50 455.4 701.5];          % 频率
fs=3200;                     % 采样频率
N=512;                       % 数据长度
n=0:N-1;                     % 数据索引
t=n/fs;
t1=(-512:511)/fs;
rad=pi/180;                  % 角度和弧度的转换因子
% 生成3个分量的信号
s1=1.01*cos(2*pi*f(1)*t+0.409);
s2=0.9*exp(-199.73*t).*cos(2*pi*f(2)*t+0.511);
s3=0.69*exp(-439.26*t).*cos(2*pi*f(3)*t+2.001);
s=s1+s2+s3;                  % 3个分量叠加在一起

Z=signal_hpronys(s,10,fs,0.0001);

K=size(Z,1);
y=zeros(1,N);
for k=1 : K                  % 显示3个分量的参数
   fprintf('%4d     alpha=%5.6f   F=%5.6f  A=%5.6f  theta=%5.6f\n',...
       k,Z(k,1),Z(k,2),Z(k,3),Z(k,4));
% 把参数合成信号
   y=y+Z(k,3)*exp(Z(k,1)*t).*cos(2*pi*Z(k,2)*t+Z(k,4));
end

snr=prony_snr(s,y);          % 计算拟合的信噪比
fprintf('SNR=%5.6f\n',snr);  % 显示信噪比值
