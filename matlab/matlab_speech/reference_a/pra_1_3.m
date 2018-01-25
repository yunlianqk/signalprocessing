%
% pra_1_3 
clear all; clc; close all;

filedir=[];                               % 设置数据文件的路径
filename='deepstep.wav';                  % 设置数据文件的名称
fle=[filedir filename]                    % 构成路径和文件名的字符串
[xx,fs]=wavread(fle);                     % 读取文件
x=xx/max(abs(xx));                        % 幅值归一化
N=length(x);                              % 信号长度
time = (0 : N-1)/fs;                      % 设置时间刻度
wlen=320;                                 % 帧长
inc=80;                                   % 帧移
nfft=512;                                 % 每帧FFT的长度
plot_spectrogram(x,wlen,inc,nfft,fs);     % 画出语谱图
title('语谱图'); xlabel('时间/s'); ylabel('频率/Hz');

y=enframe(x,wlen,inc)';                   % 分帧
fn=size(y,2);                             % 总帧数
frameTime=frame2time(fn,wlen,inc,fs);     % 每帧对应的时间
Ef=Ener_entropy(y,fn);                    % 计算能熵比值
figure(2)
pos = get(gcf,'Position');
set(gcf,'Position',[pos(1), pos(2)-100,pos(3),(pos(4)-200)]);
plot(frameTime,Ef,'k'); grid;
title('能熵比图'); xlabel('时间/s'); ylabel('幅值');
