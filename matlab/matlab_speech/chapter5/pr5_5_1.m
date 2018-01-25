%
% pr5_5_1 
clear all; clc; close all;

fp=500; fs=750;                         % 设置滤波器的通带和阻带频率
Fs=8000; Fs2=Fs/2;                      % 采样频率
Wp=fp/Fs2; Ws=fs/Fs2;                   % 把通带和阻带频率归一化
Rp=3; Rs=50;                            % 通带波纹和阻带衰减
[n,Wn]=cheb2ord(Wp,Ws,Rp,Rs);           % 求取滤波器阶数
[b,a]=cheby2(n,Rs,Wn);                  % 设计契比雪夫II型低通滤波器系数
[db,mag,pha,grd,w]=freqz_m(b,a);        % 求滤波器的频率响应曲线

filedir=[];                             % 指定文件路径
filename='bluesky3.wav';                % 指定文件名
fle=[filedir filename]                  % 构成路径和文件名的字符串
[s,fs]=audioread(fle);                    % 读入数据文件
s=s-mean(s);                            % 消除直流分量
s=s/max(abs(s));                        % 幅值归一化
N=length(s);                            % 求出信号长度
t=(0:N-1)/fs;                           % 设置时间

y=filter(b,a,s);                        % 把语音信号通过滤波器
wlen=200; inc=80; nfft=512;             % 设置帧长,帧移和nfft长
win=hann(wlen);                         % 设置窗函数
d=stftms(s,win,nfft,inc);               % 原始信号的STFT变换
fn=size(d,2);                           % 获取帧数
frameTime=(((1:fn)-1)*inc+nfft/2)/Fs;   % 计算每帧对应的时间--时间轴刻度
W2=1+nfft/2;                            % 计算频率轴刻度
n2=1:W2;
freq=(n2-1)*Fs/nfft;
d1=stftms(y,win,nfft,inc);              % 滤波后信号的STFT变换
% 作图
figure(1)                                  
plot(w/pi*Fs2,db,'k','linewidth',2)
grid; axis([0 4000 -100 5]);
title('低通滤波器的幅值响应曲线')
xlabel('频率/Hz'); ylabel('幅值/dB');
figure(2)                                  
subplot 211; plot(t,s,'k'); 
title('纯语音信号：男声“蓝天，白云”')
xlabel(['时间/s' 10 '(a)']); ylabel('幅值')
subplot 212; imagesc(frameTime,freq,abs(d(n2,:))); axis xy
title('纯语音信号的语谱图')
xlabel(['时间/s' 10 '(b)']); ylabel('频率/Hz')
m = 256;
LightYellow = [0.6 0.6 0.6];
MidRed = [0 0 0];
Black = [0.5 0.7 1];
Colors = [LightYellow; MidRed; Black];
colormap(SpecColorMap(m,Colors));
figure(3)                                 
subplot 211; plot(t,y,'k'); 
title('滤波后的语音信号')
xlabel(['时间/s' 10 '(a)']); ylabel('幅值')
subplot 212; imagesc(frameTime,freq,abs(d1(n2,:))); axis xy
title('滤波后语音信号的语谱图')
xlabel(['时间/s' 10 '(b)']); ylabel('频率/Hz')
m = 256;
LightYellow = [0.6 0.6 0.6];
MidRed = [0 0 0];
Black = [0.5 0.7 1];
Colors = [LightYellow; MidRed; Black];
colormap(SpecColorMap(m,Colors)); ylim([0 1000]);
