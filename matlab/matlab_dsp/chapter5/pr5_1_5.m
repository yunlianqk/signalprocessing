%
% pr5_1_5 
clear all; clc; close all;

fs=6400;                     % 采样频率
t = 0:1/fs:0.7;              % 时间刻度
% 电压暂降的信号
y=220*cos(2*pi*50*t).*(t<0.2)+0.6*220*cos(2*pi*50*t).*...
    (t>=0.2&t<=0.4)+220*cos(2*pi*50*t).*(t>0.4);
wlen=640;                    % 每帧长度
wind=hanning(wlen);          % 窗函数
noverlay=wlen-64;            % 相邻两帧间的重叠样点数
% 用spectrogram做STFT频谱分析
[B,freq,time]=spectrogram(y,wind,noverlay,wlen,6400);
B=B*4/wlen;                  % 计算信号的实际幅值
df=fs/wlen;                  % 求出频率间隔
%df=freq(2)-freq(1);          % 求出频率间隔
nf1=floor(50/df)+1;          % 50Hz对应的谱线索引号
nf2=floor(100/df)+1;         % 100Hz对应的谱线索引号
nf3=floor(150/df)+1;         % 150Hz对应的谱线索引号
nf4=floor(200/df)+1;         % 200Hz对应的谱线索引号
nf5=floor(250/df)+1;         % 250Hz对应的谱线索引号
nf6=floor(300/df)+1;         % 300Hz对应的谱线索引号
% 作图
figure(1);
subplot 211; plot(t,y,'k');
ylabel('幅值'); xlabel('时间/s');
title('电压暂降原始波形');
subplot 212; imagesc(time,freq,abs(B)); axis xy
xlabel('时间/s'); ylabel('频率/Hz');
title('电压暂降信号STFT谱图');
ylim([0 500]);
set(gcf,'color','w');
figure(2)
subplot 321; plot(time,abs(B(nf1,:)),'k'); 
xlim([0 max(time)]); ylabel('50Hz');
subplot 322; plot(time,abs(B(nf2,:)),'k'); 
axis([0 max(time) 0 10]); ylabel('100Hz');
subplot 323; plot(time,abs(B(nf3,:)),'k'); 
axis([0 max(time) 0 5]); ylabel('150Hz');
subplot 324; plot(time,abs(B(nf4,:)),'k'); 
axis([0 max(time) 0 5]); ylabel('200Hz');
subplot 325; plot(time,abs(B(nf5,:)),'k'); 
axis([0 max(time) 0 5]); ylabel('250Hz'); xlabel('时间/s');
subplot 326; plot(time,abs(B(nf6,:)),'k'); 
axis([0 max(time) 0 5]); ylabel('300Hz'); xlabel('时间/s');
set(gcf,'color','w');

