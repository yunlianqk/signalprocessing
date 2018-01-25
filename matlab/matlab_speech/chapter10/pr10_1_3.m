%
% pr10_1_3 
clear all; clc; close all;

load Labdata1                 % 读入实验数据和延伸数据
N=length(xx);                 % 数据长
time=(0:N-1)/fs;              % 时间标度
T=10091-8538+1;               % 缺少数据区间的长度
x1=xx(1:8537);                % 前段数据
x2=xx(10092:29554);           % 后段数据
y1=ydata(:,1);                % 延伸数据1
xx1=[x1; y1; x2];             % 以延伸数据1合成
y2=ydata(:,2);                % 延伸数据2
xx2=[x1; y2; x2];             % 以延伸数据2合成
% 用延伸数据1和延伸数据2以线性比例重叠相加合成
Wt1=(0:T-1)'/T;               % 构成斜三角窗函数w1
Wt2=(T-1:-1:0)'/T;            % 构成斜三角窗函数w2
y=y1.*Wt2+y2.*Wt1;            % 线性比例重叠相加
xx3=[x1; y; x2];              % 合成数据
%作图
pos = get(gcf,'Position');
set(gcf,'Position',[pos(1), pos(2)-100,pos(3),pos(4)-240]);
plot(time,xx,'k'); axis([0 29.6 -15 10]); 
title('原始信号的波形'); xlabel('时间/s'); ylabel('幅值')
line([8.537 8.537],[-15 10],'color','k','linestyle','-');
line([10.092 10.092],[-15 10],'color','k','linestyle','--');

figure(2)
pos = get(gcf,'Position');
set(gcf,'Position',[pos(1), pos(2)-100,pos(3),pos(4)+50]);
subplot 221; plot(time,xx1,'k'); axis([9.5 10.5 -10 5]);
line([10.091 10.091],[-15 10],'color','k','linestyle','-.');
title('第一段延伸后合成的波形'); xlabel(['时间/s' 10 '(a)']); ylabel('幅值')
subplot 222; plot(time,xx2,'k'); axis([8 9.5 -10 5]); 
line([8.538 8.538],[-15 10],'color','k','linestyle','-.');
title('第二段延伸后合成的波形'); xlabel(['时间/s' 10 '(b)']); ylabel('幅值')
subplot 212; plot(time,xx3,'k');  axis([0 29.6 -15 10]); 
line([8.537 8.537],[-15 10],'color','k','linestyle','-');
line([10.092 10.092],[-15 10],'color','k','linestyle','--');
title('线性比例重叠相加后合成的波形'); xlabel(['时间/s' 10 '(c)']); ylabel('幅值')

