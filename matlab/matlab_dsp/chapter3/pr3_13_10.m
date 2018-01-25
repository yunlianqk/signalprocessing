%
% pr3_13_10 
clear all; clc; close all;

N=33;                            % 设置滤波器长
f=0:0.05:0.95;                   % 设置频率点
a=f*pi;                          % 设置对应频率点的幅值
b=firpm(N,f,a,'differentiator'); % 用等波纹法设计
[db,mag,pha,grd,w]=freqz_m(b,1); % 求频域响应
% 作图
subplot 211; stem(b,'k');
title('微分器的脉冲响应')
xlabel('样点'); ylabel('幅值')
subplot 212; plot(w/pi,mag,'k','linewidth',2); 
grid; title('微分器的幅频特性')
xlabel('归一化频率'); ylabel('幅值')
set(gcf,'color','w');


