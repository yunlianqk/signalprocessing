%
% pr3_7_14 
clear all; close all; clc;

load ydata1.mat                 % 读入数据
Fs=400; Fs2=Fs/2;               % 设置采样频率和奈奎斯特频率
N=length(y);                    % 数据长度
t=(0:N-1)/Fs;                   % 时间刻度

fp=20; fs=30;                   % 通带和阻带频率
Rp=2; Rs=40;                    % 通带波纹和阻带衰减
Wp=fp/Fs2; Ws=fs/Fs2;           % 通带和阻带频率归一化
[M,Wn]=cheb2ord(Wp,Ws,Rp,Rs);   % 计算滤波器阶数
[bn,an]=cheby2(M,Rs,Wn);        % 求得滤波器系数
% 第1种方法 
x1=filter(bn,an,y);             % 第1次滤波
x2=flipud(x1);                  % 时域数据翻转排列
y2=filter(bn,an,x2);            % 第2次滤波
y1=flipud(y2);                  % 时域数据再一次翻转排列
% 第2种方法 
yy=filtfilt(bn,an,y);           % 用filtfilt函数进行零相位滤波
% 作图
plot(t,y,'r','linewidth',2); hold on
plot(t,x1,'k--','linewidth',2);
plot(t,y1,'k','linewidth',2);
legend('原始数据','第1次通过滤波器输出','第2次通过滤波器输出');
xlabel('时间/s'); ylabel('幅值');
title('原始数据及两次通过滤波器输出数据的波形图')
set(gcf,'color','w');
figure(2)
line([t],[y1],'color',[.6 .6 .6],'linewidth',3); hold on
plot(t,yy,'k--','linewidth',2);
legend('第1种方法的输出','第2种方法的输出');
xlabel('时间/s'); ylabel('幅值');
title('两种零相位滤波法的比较')
box on; set(gcf,'color','w');


