%
% pr4_1_1 
clear all; clc; close all;

load ecgdata2.mat                   % 读入心电图数据
N=length(y);                        % 数据长度
time=(0:N-1)/fs;                    % 计算出时间刻度
[x,xtrend]=polydetrend(y, fs, 3);   % 用多项式拟合法求出趋势项及消除后的序列
% 作图
subplot 311; plot(time,y,'k')
title('输入心电信号'); ylabel('幅值');
axis([0 max(time) -2000 6000]); grid;
subplot 312; plot(time,xtrend,'k','linewidth',1.5);
title('趋势项信号'); ylabel('幅值');
axis([0 max(time) -2000 6000]); grid;
subplot 313; plot(time,x,'k'); 
title('消除趋势项心电信号'); ylabel('幅值');
xlabel('时间/s');
axis([0 max(time) -2000 6000]); grid;
set(gcf,'color','w');
