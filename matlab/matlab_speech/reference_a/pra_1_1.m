%
% pra_1_1 
clear all; clc; close all;

filedir=[];                               % 设置数据文件的路径
filename='colorcloud.wav';                % 设置数据文件的名称
fle=[filedir filename]                    % 构成路径和文件名的字符串
[xx,fs]=wavread(fle);                     % 读取文件
xx=xx/max(abs(xx));                       % 幅值归一化
N=length(xx);                             % 信号长度
time = (0 : N-1)/fs;                      % 设置时间刻度
wlen=320;                                 % 帧长
inc=80;                                   % 帧移
yy=enframe(xx,wlen,inc)';                 % 消除直流分量前分帧
fn=size(yy,2);                            % 帧数
frameTime=frame2time(fn,wlen,inc,fs);     % 每帧对应的时间
Ef=Ener_entropy(yy,fn);                   % 计算能熵比值
figure(1)
pos = get(gcf,'Position');
set(gcf,'Position',[pos(1), pos(2)-100,pos(3),(pos(4)-100)]);
subplot 211; plot(time,xx,'k');
line([0 max(time)],[0 0],'color','k','linestyle','-.');
title('消除直流分量前的信号波形图'); xlabel('时间/s'); ylabel('幅值');
subplot 212; plot(frameTime,Ef,'k'); grid;
title('能熵比图'); xlabel('时间/s'); ylabel('幅值');

xx=xx-mean(xx);                           % 消除直流分量
x=xx/max(abs(xx));                        % 幅值归一化
y=enframe(x,wlen,inc)';                   % 消除直流分量后分帧
Ef=Ener_entropy(y,fn);                    % 计算能熵比值
figure(2)
pos = get(gcf,'Position');
set(gcf,'Position',[pos(1), pos(2)-100,pos(3),(pos(4)-100)]);
subplot 211; plot(time,x,'k');
line([0 max(time)],[0 0],'color','k','linestyle','-.');
title('消除直流分量后的信号波形图'); xlabel('时间/s'); ylabel('幅值'); 
subplot 212; plot(frameTime,Ef,'k'); grid;
title('能熵比图'); xlabel('时间/s'); ylabel('幅值');

