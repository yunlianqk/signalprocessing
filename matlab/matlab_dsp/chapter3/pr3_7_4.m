%
% pr3_7_4 
clear all; clc; close all;

load bzsdata.mat                % 读入数据
N=length(bzs);                  % 原始数据长
t=(0:N-1)/Fs;                   % 设置时间

x=resample(bzs,1,5);            % 降采样
N1=length(x);                   % 降采样后的长度
fs=Fs/5;                        % 降采样后的采样频率
fs2=fs/2;                       % 降采样后采样频率的一半
t1=(0:N1-1)/fs;                 % 降采样后的时间刻度

fp1=[1.5 10];                   % 通带频率
fs1=[1 12];                     % 阻带频率
wp1=fp1/fs2;                    % 归一化通带频率
ws1=fs1/fs2;                    % 归一化阻带频率
Ap=3; As=15;                    % 通带波纹和阻带衰减
[n,Wn]=buttord(wp1,ws1,Ap,As);  % 求滤波器原型阶数和带宽
[bn1,an1]=butter(n,Wn);         % 求数字滤波器系数
[H,f]=freqz(bn1,an1,1000,fs);   % 求数字滤波器幅频曲线

y1=filter(bn1,an1,x);           % 对降采样后的数据进行滤波
y=resample(y1,5,1);             % 对滤波器输出恢复原采样频率
% 作图
figure(1)
subplot 311; plot(t,bzs,'k');
xlabel('时间/秒'); title('原始数据波形')
subplot 312; plot(t1,x,'k');
xlabel('时间/秒'); title('降采样后数据波形')
subplot 313; plot(t,y,'k')
xlabel('时间/秒'); title('滤波后数据波形')
set(gcf,'color','w');
figure(2)
plot(f,abs(H),'k');
grid; axis([0 25 0 1.1]); 
xlabel('频率/Hz'); ylabel('幅值')
title('巴特沃斯滤波器的幅值响应')
set(gcf,'color','w');

