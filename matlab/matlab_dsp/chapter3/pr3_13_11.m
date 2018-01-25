%
% pr3_13_11
clear all; clc; close all;

N=50;                                % 设置滤波器长
M=N+1;                               % 希尔伯特变换器长
f = [0.05,0.95];                     % 设置频率点
a = [1 1];                           % 设置对应频率点的幅值
h = firpm(N,f,a,'hilbert');          % 用等波纹法设计
[db,mag,pha,grd,w]=freqz_m(h,[1]);   % 求频域响应
% 作图
subplot(1,1,1)
subplot(2,1,1); stem([0:N],h,'k'); 
title('希尔伯特变换器的脉冲响应')
xlabel('样点'); ylabel('幅值')
axis([0,N,-0.8,0.8])
set(gca,'XTickMode','manual','XTick',[0,N])
set(gca,'YTickMode','manual','YTick',[-0.8:0.2:0.8]);
subplot(2,1,2); plot(w/pi,mag,'k','linewidth',2); 
grid; title('希尔伯特变换器的幅频特性')
xlabel('归一化频率'); ylabel('幅值')
set(gca,'XTickMode','manual','XTick',[0,f,1])
set(gca,'YTickMode','manual','YTick',[0,1]);
set(gcf,'color','w');
