%
% pr3_13_3 
clear all; clc; close all

Fs=100;                                 % 采样频率
Fs2=Fs/2;                               % 奈奎斯特频率
fp=3; fs=5;                             % 通带和阻带频率
Rp=3; As=50;                            % 通带波纹和阻带衰减
delta1 = (10^(Rp/20)-1)/(10^(Rp/20)+1); % 求通带波纹线性值
delta2 = (1+delta1)*(10^(-As/20));      % 求阻带衰减线性值
f=[fp fs]/Fs2; A=[1 0];                 % 设置频率指标f和幅值指标A
dev=[delta1 delta2];                    % 设置偏离指标dev
[N,Wn,beta,ftype] = kaiserord(f,A,dev); % 用kaiserord函数计算阶数和其他参数
N=N+rem(N,2);                           % 保证滤波器系数长N+1为奇数
b=fir1(N,Wn,kaiser(N+1,beta));          % 用fir1函数凯泽窗函数设计FIR第1类滤波器
[db,mag,phs,gdy,w]=freqz_m(b,1);        % 计算滤波器频域响应
% 作图
subplot 211; plot(w*Fs/(2*pi),db,'k','linewidth',2);
title('低通滤波器幅值响应');
grid; axis([0 20 -70 10]); 
xlabel('频率/Hz');  ylabel('幅值/dB')
set(gca,'XTickMode','manual','XTick',[0,3,5,20])
set(gca,'YTickMode','manual','YTick',[-50,0])
subplot 212; stem(1:N+1,b,'k');
title('低通滤波器脉冲响应');
xlabel('样点');  ylabel('幅值')
axis([0 N+1 -0.05 0.1]); %grid;
set(gca,'XTickMode','manual','XTick',[1,(N+2)/2,N+1])
set(gcf,'color','w');

