%
% pr5_4_2  
clear all; clc; close all;

[x,fs,nbit]=wavread('bluesky32.wav');     % 读入bluesky32.wav文件

[y,xtrend]=polydetrend(x, fs, 2);         % 调用polydetrend消除趋势项
t=(0:length(x)-1)/fs;                     % 设置时间
subplot 211; plot(t,x,'k');               % 画出带有趋势项的语音信号x
line(t,xtrend,'color',[.6 .6 .6],'linewidth',3); % 画出趋势项曲线
ylim([-1.5 1]);
title('带趋势项的语音信号');
legend('带趋势项的语音信号','趋势项信号',4)
xlabel('时间/s'); ylabel('幅值');
subplot 212; plot(t,y,'k');               % 画出消除趋势项的语音信号y
xlabel('时间/s'); ylabel('幅值');
title('消除趋势项的语音信号');


