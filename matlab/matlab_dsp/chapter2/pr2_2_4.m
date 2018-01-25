%
% pr2_2_4 
clear all; clc; close all;

fs=1000;                       % 采样频率
f0=50;                         % 信号频率
A=1;                           % 信号幅值
theta0=pi/3;                   % 信号初始相角
N=1000;                        % 信号长度
t=(0:N-1)/fs;                  % 设置时间序列
x=A*cos(2*pi*f0*t+theta0);     % 设置信号
X=fft(x);                      % FFT
n2=1:N/2+1;                    % 设置索引号序列
freq=(n2-1)*fs/N;              % 设置频率刻度
% 第一部分
THETA=angle(X(n2));            % 计算初始相角
Am=abs(X(n2));                 % 计算幅值
ph0=THETA(51);                 % 计算信号的初始相角
fprintf('ph0=%5.4e   %5.4e   %5.4e\n',real(X(51)),imag(X(51)),ph0);
% 作图
subplot 211; plot(freq,abs(X(n2))*2/N,'k');
xlabel('频率/Hz'); ylabel('幅值')
title('幅值谱图')
subplot 212; plot(freq,THETA,'k')
xlabel('频率/Hz'); ylabel('初始角/弧度')
title('相位谱图')
set(gcf,'color','w');
pause
% 第二部分
Th=0.1;                        % 设置阈值
thetadex=find(Am<Th);          % 寻找小于阈值的那线谱线的索引
THETA1=THETA;                  % 初始化THETA1
THETA1(thetadex)=0;            % 对于小于阈值的那线谱线初始相位都为0
% 作图
figure
pos = get(gcf,'Position');
set(gcf,'Position',[pos(1), pos(2)-100,pos(3),(pos(4)-160)]);
plot(freq,THETA1,'k')
xlabel('频率/Hz'); ylabel('初始角/弧度')
title('相位谱图')
set(gcf,'color','w');



