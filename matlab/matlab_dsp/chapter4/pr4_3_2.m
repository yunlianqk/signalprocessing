%
% pr4_3_2 
clear all; clc; close all;

xx=load('pulsedata0.txt');   % 读入信号
N=length(xx);                % 数据长度
n=1:N;                       % 设置样点序列
% 作图
plot(n,xx,'k'); grid;
xlabel('样点'); ylabel('幅值');
title('原始信号波形图')
set(gcf,'color','w');

% 程序第一部分用hilbert计算信号的包络
xm=sum(xx)/N;                % 计算信号的直流分量
x=xx-xm;                     % 消除直流分量
z=hilbert(x);                % 进行希尔伯特变换
% 作图
figure(2)
plot(n,x,'k'); hold on; grid;
plot(n,abs(z),'r');
xlabel('样点'); ylabel('幅值');
title('消除直流分量用求取包络曲线图')
set(gcf,'color','w');

% 程序第二部分用求极大极小值计算信号的包络 
% 利用findpeakm函数计算信号的极大极小值
[K1,V1]=findpeakm(x,[],120); % 求极大值位置和幅值
up=spline(K1,V1,n);          % 内插,获取上包络曲线
[K2,V2]=findpeakm(x,'v',120);% 求极小值位置和幅值
down=spline(K2,V2,n);        % 内插,获取下包络曲线
% 作图
figure(3)
plot(n,x,'k'); hold on; grid;
plot(n,up,'r');
plot(n,down,'r');
xlabel('样点'); ylabel('幅值');
title('用求取极大极小值方法获取包络曲线图')
set(gcf,'color','w');

