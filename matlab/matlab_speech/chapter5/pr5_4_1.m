%
% pr5_4_1 
clear all; clc; close all;

[x,fs]=audioread('bluesky32.wav');     % 读入bluesky31.wav文件
t=(0:length(x)-1)/fs;                     % 设置时间
y=polydetrend(x,fs,3);                             % 消除线性趋势项
y=y/max(abs(y));                          % 幅值归一化
subplot 211; plot(t,x,'b');               % 画出带有趋势项的语音信号x
title('带趋势项的语音信号');
xlabel('时间/s'); ylabel('幅值');
subplot 212; plot(t,y,'k');               % 画出消除趋势项的语音信号y
xlabel('时间/s'); ylabel('幅值');
title('消除趋势项的语音信号');


