%
% pr4_5_3 from zw21
clear all; clc; close all;

t=0:.2:199;            % 设置时间序列
s=10*sin(0.4*pi*t);    % 原始信号
ns=randn(size(s));     % 产生噪声序列
y=s+ns;                % 构成带噪信号
x=sgolayfilt(y,3,19);  % 通过Savitzky-Golay滤波器
% 作图
figure
plot(t,y,'r'); 
xlim([0 20]); hold on; grid;
plot(t,x,'k');
xlabel('时间'); ylabel('幅值');
title('Savitzky-Golay滤波器的输/输出波形图')
set(gcf,'color','w');
