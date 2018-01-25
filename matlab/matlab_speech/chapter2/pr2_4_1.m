%
% pr2_4_1
clear all; clc; close all;

filedir=[];                         % 设置路径
filename='bluesky3.wav';            % 设置文件名
fle=[filedir filename];             % 构成完整的路径和文件名
[x,Fs]=wavread(fle);                % 读入数据文件
wlen=200; inc=80; win=hanning(wlen);% 设置帧长，帧移和窗函数
N=length(x); time=(0:N-1)/Fs;       % 计算时间
y=enframe(x,win,inc)';              % 分帧
fn=size(y,2);                       % 帧数
frameTime=(((1:fn)-1)*inc+wlen/2)/Fs; % 计算每帧对应的时间
W2=wlen/2+1; n2=1:W2;
freq=(n2-1)*Fs/wlen;                % 计算FFT后的频率刻度
Y=fft(y);                           % 短时傅里叶变换
clf                                 % 初始化图形
%=====================================================%
% Plot the STFT result              % 画出语谱图        
%=====================================================%
set(gcf,'Position',[20 100 600 500]);            
axes('Position',[0.1 0.1 0.85 0.5]);  
imagesc(frameTime,freq,abs(Y(n2,:))); % 画出Y的图像  
axis xy; ylabel('频率/Hz');xlabel('时间/s');
title('语谱图');
m = 64;
LightYellow = [0.6 0.6 0.6];
MidRed = [0 0 0];
Black = [0.5 0.7 1];
Colors = [LightYellow; MidRed; Black];
colormap(SpecColorMap(m,Colors));

%=====================================================%
% Plot the Speech Waveform          % 画出语音信号的波形  
%=====================================================%
axes('Position',[0.07 0.72 0.9 0.22]);
plot(time,x,'k');
xlim([0 max(time)]);
xlabel('时间/s'); ylabel('幅值');
title('语音信号波形');
