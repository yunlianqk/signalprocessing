% 
% pr3_13_4 
clear all; clc; close all

Fs=250;                                      % 采样频率
Fs2=Fs/2;                                    % 奈奎斯特频率
fp1=45; fs1=49;                              % 通带和阻带频率
fs2=51; fp2=55; 
wp1 = fp1*pi/Fs2; ws1 = fs1*pi/Fs2;          % 通带和阻带归一化角频率
ws2 = fs2*pi/Fs2; wp2 = fp2*pi/Fs2; 
As = 20;                                     % 设定阻带衰减
tr_width = min((ws1-wp1),(wp2-ws2));         % 过渡带宽Δω的计算
M = ceil(6.2*pi/tr_width);                   % 按海明窗计算所需的滤波器阶数M
M=M+mod(M,2);                                % 保证滤波器系数长M+1为奇数
fc1 = (ws1+wp1)/2/pi; fc2 = (wp2+ws2)/2/pi;  % 求截止频率的归一化值

% 用fir1函数
h1 = fir1(M,[fc1 fc2],'stop',hanning(M+1)'); % 用fir1函数计算理想滤波器脉冲响应
[db1,mag,pha,grd,w1] = freqz_m(h1,[1]);      % 求出频域响应
% 作图
plot(w1*Fs2/pi,db1,'k'); 
title('FIR陷波器幅值响应');grid;
xlabel('频率/Hz'); ylabel('幅值/dB')
axis([0 Fs2 -60 10]); hold on
set(gca,'XTickMode','manual','XTick',[0,45,50,55,125])
set(gca,'YTickMode','manual','YTick',[-40,-20,0])
set(gcf,'color','w');

