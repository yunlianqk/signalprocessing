%
% pr4_3_3
clear all; clc; close all;

n=-5000:20:5000;            % 样点设置
N=length(n);                % 信号样点数
nt=0:N-1;                   % 设置样点序列号
x=120+96*exp(-(n/1500).^2).*cos(2*pi*n/600); % 设置信号
[up,down] = envelope(n,x,'splin');
% 作图
plot(nt,x,'k',nt,up,'r',nt,down,'g');
xlabel('样点'); ylabel('幅值'); grid;
title('调用envelope函数求取上下包络曲线图')
set(gcf,'color','w');


