%
% pr3_7_12 
clear all; clc; close all;

load('noisyecg.mat');              % 读入信号数据和采样频率
x=noisyecg;                        % 信号为x
N=length(x);                       % 信号长N
t =(0:N-1)./fs;                    % 时间刻度 
fs2=fs/2;                          % 设置奈奎斯特频率
W0=50/fs2;                         % 陷波器中心频率
BW=0.1;                            % 陷波器带宽 
[b,a]=iirnotch(W0,BW);             % 设计IIR数字陷波器
[H,w]=freqz(b,a);                  % 求出滤波器的频域响应
y=filter(b,a,x);                   % 对信号滤波
% 作图
plot(w*fs/2/pi,20*log10(abs(H)),'k');
xlabel('频率/Hs'); ylabel('幅值/dB');
title('陷波器幅值响应图')
axis([0 125 -45 5]); grid;
set(gca,'XTickMode','manual','XTick',[0,40,50,60,100])
set(gca,'YTickMode','manual','YTick',[-40,-30,-20,-10,0])
set(gcf,'color','w');
figure(2)
subplot 211; plot(t,x,'k','linewidth',2);
xlabel('时间/s'); ylabel('幅值');
title('带噪心电波形图')
subplot 212; plot(t,y,'k');
xlabel('时间/s'); ylabel('幅值');
title('消噪后心电波形图')
set(gcf,'color','w');

%save ntchdata1.mat w H b a
b
a