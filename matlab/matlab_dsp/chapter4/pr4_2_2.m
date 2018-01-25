%
% pr4_2_2 
clear all; clc; close all;

load SDqdata2.mat                      % 读入信号
y=-mix_signal;                         % 把输入信号反相
% 信号反相后用findpeaks函数检测峰值替代谷值的检测
[Val,Locs]=findpeaks(y,'MINPEAKHEIGHT',-1400,'MINPEAKDISTANCE',5);
b0=interp1(time(Locs),-Val,time);      % 延伸谷值,构成基线偏离曲线
x=-y-b0;                               % 基线拉平的信号
% 作图 
subplot 211; plot(time,y,'k'); hold on; grid
plot(time(Locs),Val,'r.','linewidth',3);
xlabel('时间/s'); ylabel('幅值'); 
title('把信号颠倒过来用寻找峰值替代寻找谷值'); 
subplot 212; plot(time,x,'k');
xlabel('时间/s'); ylabel('幅值');
title('把基线拉平后的波形图'); grid;
set(gcf,'color','w');




