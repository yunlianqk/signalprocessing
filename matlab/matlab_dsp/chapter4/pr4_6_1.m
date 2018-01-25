%
% pr4_6_1 
clear all; clc; close all

N = 1000;                    % 数据长度
Fs = 1000;                   % 采样频率
t = (0:N-1)/Fs;              % 时间刻度
% 滤波器设计
fp=[3 15];                   % 滤波器通带阻带参数设定
fs = [0.5 30];
rp = 1.5;                    % 通带波纹
rs = 20;                     % 阻带衰减
wp = fp*2/Fs;                % 归一化频率
ws = fs*2/Fs;
[n,wn]=buttord(wp,ws,rp,rs); % 计算滤波器阶数
[b,a] = butter(n,wn);        % 计算滤波器系数
[h,w] = freqz(b,a,1000,Fs);  % 求滤波器响应
h = 20*log10(abs(h));        % 计算滤波器幅值响应 

%信号的产生
f1 = 0.001;                  % 分量1,准直流
f2 = 5;                      % 分量2,有用信号
f3 = 50;                     % 分量3,工频干扰
x1 = 100+10*sin(2*pi*f1*t);  % 产生3个分量的信号
x2 = 10*sin(2*pi*f2*t);
x3 = 10*sin(2*pi*f3*t);
xn = x1+x2+x3;               % 合并为信号xn
y1=filtfilt(b,a,xn);         % 做零相位带通滤波
Segma1=var(y1-x2);           % 计算方差
L=400;                       % 设置延拓长度
yn=forback_predictm(xn,L,10);% 前后向延拓
ynt = filtfilt(b,a,yn);      % 做零相位带通滤波
y2 = ynt((L+1):(L+N));       % 消去延拓部分
Segma2=var(y2'-x2);          % 计算方差
fprintf('Segma1=%5.4f   Segma2=%5.4f\n',Segma1,Segma2);
% 作图
figure(1)
plot(w,h,'k');
grid; axis([0 50 -50 10]);
title('巴特沃斯滤波器幅值特性')
ylabel('幅值/dB');xlabel('频率/Hz');
set(gcf,'color','w');
figure(2)
n=1:N;
subplot 311; plot(n,xn,'k'); 
grid; ylabel('原始信号')
subplot 312; plot(n,x2,'r','linewidth',3); hold on;
plot(n,y1,'k'); grid;
ylabel('未经延拓的输出')
subplot 313; plot(n,x2,'r','linewidth',3); hold on;
plot(n,y2,'k'); grid;   xlabel('样点')
ylabel('经延拓的输出')
set(gcf,'color','w');

