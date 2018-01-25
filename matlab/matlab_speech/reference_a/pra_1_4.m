%
% pra_1_4    
clear all; clc; close all;

[xx,fs]=wavread('hello28n.wav');        % 读入数据文件
xx=xx-mean(xx);                         % 消除直流分量
signal=xx/max(abs(xx));                 % 幅值归一化

IS=1;                                   % 设置前导无话段长度
wlen=200;                               % 设置帧长为25ms
inc=80;                                 % 设置帧移为10ms
N=length(xx);                           % 帧数
time=(0:N-1)/fs;                        % 设置时间
NIS=fix((IS*fs-wlen)/inc +1);           % 求前导无话段帧数

a=4; b=0.001;                           % 设置参数a和b
output=simplesubspec(signal,wlen,inc,NIS,a,b);% 谱减
% 作图
subplot 211; plot(time,signal,'k'); grid; axis tight;
title(['带噪语音信号']); ylabel('幅值')
subplot 212; plot(time,output,'k');grid;  axis tight;
title('谱减后信号波形'); ylabel('幅值'); xlabel('时间/s');



        
