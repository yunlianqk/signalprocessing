%
% pr4_5_1 from wn11
clear all; clc; close all;

xx=load('xnoisedata1.txt');     % 读入数据
time=xx(:,1);                   % 时间序列
x=xx(:,2);                      % 带噪数据
xmean=mean5_3(x,50);            % 调用mean5_3函数,平滑数据
% 作图
subplot 211; plot(time,x,'k');
xlabel('时间/s'); ylabel('幅值')
title('原始数据'); xlim([0 max(time)]);
subplot 212; plot(time,xmean,'k'); 
xlabel('时间/s'); ylabel('幅值')
title('平滑处理后的数据'); xlim([0 max(time)]);
set(gcf,'color','w');




