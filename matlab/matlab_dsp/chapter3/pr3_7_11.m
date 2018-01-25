%
% pr3_7_11 
clear all; clc; close all;

fs=1600;                             % 采样频率
f0=50;                               % 基波频率
N=800;                               % 数据长度
t=(0:N-1)/fs;                        % 时间刻度
x=zeros(1,N);                        % x初始化
for k=1 : 2 : 10                     % 产生信号
    x=x+(10/pi/k)*sin(2*pi*k*f0*t);  
end

fs2=fs/2;                            % 奈奎斯特频率
wp=[40 60]/fs2; ws=[30 80]/fs2;      % 通带和阻带
Rp=1; Rs=40;                         % 通带波纹和阻带衰减
[M,Wn]=ellipord(wp,ws,Rp,Rs);        % 求原型滤波器阶数和带宽
[B,A]=ellip(M,Rp,Rs,Wn);             % 求数字滤波器系数
x1=x(1:400); x2=x(401:800);          % 设置相邻的两组数据
% 第一部分-用filter函数但不带zi和zf参数
y1=filter(B,A,x1);                   % 分别对两组数据滤波
y2=filter(B,A,x2);
y=[y1 y2];                           % 把两组数合并成输出数据
% 作图
figure(1)
subplot 211; plot(t,x,'k');
title('输入信号波形');
xlabel('时间/s'); ylabel('幅值');
subplot 212; plot(t,y,'k');
title('不带zi和zf参数filter的输出信号波形');
xlabel('时间/s'); ylabel('幅值');
set(gcf,'color','w');

% 第二部分-用filter函数并使用zi和zf参数
zi=zeros(6,1);                       % 初始化
[u1,zf]=filter(B,A,x1,zi);           % 分别对两组数据滤波
zi=zf;
[u2,zf]=filter(B,A,x2,zi);
u=[u1 u2];                           % 把两组数合并成输出数据
% 作图
figure(2)
pos = get(gcf,'Position');
set(gcf,'Position',[pos(1), pos(2)-100,pos(3),(pos(4)-200)]);
plot(t,u,'k');
title('带zi和zf参数filter的输出信号波形');
xlabel('时间/s'); ylabel('幅值');
set(gcf,'color','w');

