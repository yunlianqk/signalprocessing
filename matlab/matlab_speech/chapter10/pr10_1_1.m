% pr10_1_1  
% 把conv与重叠相加卷积conv_ovladd函数做比较
%
clear all; clc; close all;
y=load('data1.txt')';                   % 读入数据
M=length(y);                            % 数据长
t=0:M-1;                        
h=fir1(100,0.125);                      % 设计FIR滤波器
x=conv(h,y);                            % 用conv函数进行数字滤波
x=x(51:1050);                           % 取无延迟的滤波器输出
z=conv_ovladd1(y,h,256);                % 通过重叠相加法计算卷积
% 作图
pos = get(gcf,'Position');
set(gcf,'Position',[pos(1), pos(2)-100,pos(3),(pos(4)-140)]);
plot(t,y,'k');
title('信号的原始波形')
xlabel('样点'); ylabel('幅值');
%xlabel('n'); ylabel('Am');
figure(2)
pos = get(gcf,'Position');
set(gcf,'Position',[pos(1), pos(2)-100,pos(3),(pos(4)-100)]);
hline1 = plot(t,z,'k','LineWidth',1.5); 
hline2 = line(t,x,'LineWidth',5,'Color',[.6 .6 .6]);
set(gca,'Children',[hline1 hline2]);
title('卷积和重叠相加卷积的比较')
xlabel('样点'); ylabel('幅值');
legend('卷积conv','重叠相加卷积',2)
ylim([-0.8 1]);