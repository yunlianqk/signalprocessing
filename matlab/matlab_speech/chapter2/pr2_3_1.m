%
% pr2_3_1
clear all; clc; close all;

filedir=[];                % 设置路径
filename='bluesky3.wav';   % 设置文件名
fle=[filedir filename];    % 构成完整的路径和文件名
[x,Fs]=wavread(fle);       % 读入数据文件

wlen=200; inc=80;          % 给出帧长和帧移
win=hanning(wlen);         % 给出海宁窗
N=length(x);               % 信号长度
X=enframe(x,win,inc)';     % 分帧
fn=size(X,2);              % 求出帧数
time=(0:N-1)/Fs;           % 计算出信号的时间刻度
for i=1 : fn
    u=X(:,i);              % 取出一帧
    u2=u.*u;               % 求出能量
    En(i)=sum(u2);         % 对一帧累加求和
end
subplot 211; plot(time,x,'k'); % 画出时间波形 
title('语音波形');
ylabel('幅值'); xlabel(['时间/s' 10 '(a)']);
frameTime=frame2time(fn,wlen,inc,Fs);   % 求出每帧对应的时间
subplot 212; plot(frameTime,En,'k')     % 画出短时能量图
title('短时能量');
 ylabel('幅值'); xlabel(['时间/s' 10 '(b)']);
