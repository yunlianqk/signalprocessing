%
% pra_1_2 
clear all; clc; close all;

[xx,fs,nbit]=wavread('digits1_10.wav');
N=length(xx);
time=(0:N-1)/fs;                          % 计算时间刻度
x1=xx/max(abs(xx));                       % 幅值归一化
wlen=320;                                 % 帧长
inc=80;                                   % 帧移
yy=enframe(x1,wlen,inc)';                 % 分帧
fn=size(yy,2);                            % 帧数
frameTime=frame2time(fn,wlen,inc,fs);     % 每帧对应的时间
Ef=Ener_entropy(yy,fn);                   % 计算能熵比值
figure(1)
pos = get(gcf,'Position');
set(gcf,'Position',[pos(1), pos(2)-100,pos(3),(pos(4)-100)]);
subplot 211; plot(time,x1,'k'); 
axis([0 max(time) -1 1]);
title('带有趋势项的语音信号'); xlabel('(a)'); ylabel('幅值');
subplot 212; plot(frameTime,Ef,'k'); grid;
title('能熵比图'); xlabel(['时间/s' 10 '(b)']); ylabel('幅值');
axis([0 max(time) 0 1]);

xx=xx/max(abs(xx));                       % 幅值归一化
[x,xtrend]=polydetrend(xx, fs, 4);        % 消除趋势项
y=enframe(x,wlen,inc)';                   % 分帧
Ef=Ener_entropy(y,fn);                    % 计算能熵比值
figure(2)
pos = get(gcf,'Position');
set(gcf,'Position',[pos(1), pos(2)-100,pos(3),(pos(4)-100)]);
subplot 211; plot(time,x,'k');
line([0 max(time)],[0 0],'color','k');
title('消除趋势项的语音信号'); xlabel('(a)'); ylabel('幅值');
axis([0 max(time) -1 1]);
subplot 212; plot(frameTime,Ef,'k'); grid;
title('能熵比图'); xlabel(['时间/s' 10 '(b)']); ylabel('幅值');
axis([0 max(time) 0 1]);
figure(1); subplot 211;
line([time],[xtrend],'color',[.6 .6 .6],'linewidth',2);

