%
% pr5_1_4 
clear all; clc; close all;

load cjbdata.mat                 % 读入数据
N=length(y);                     % 数据长度
t=(0:N-1)*1000/fs;               % 时间刻度
M=256;                           % FFT变换长度
width=fix((N+1)/4);              % 窗函数长
h=hanning(width);                % 设置窗函数
[S,tt,f]=tfrstft(y,1:N,M,h);     % STFT变换
[x,t_s]=tfristft(S,tt,h);        % ISTFT变换
Segma=var(x-y);
fprintf('Segma=%5.4e\n',Segma)
% 作图
figure(1)
subplot 211; plot(t,y,'k'); grid;
ylabel('加速度/g'); xlabel('时间/ms');
title('原始信号波形'); xlim([0 max(t)]);
subplot 212; imagesc(t,f(1:128)*fs/1000,abs(S(1:128,:)));
title('信号STFT谱图'); xlabel('时间/ms'); ylabel('频率/kHz');
axis([0 max(t) 0 15]); axis xy;
set(gcf,'color','w');
figure(2)
plot(tt,y,'r','linewidth',3); hold on
plot(t_s,x,'k'); grid;
legend('原始信号','重构信号')
ylabel('加速度/g'); xlabel('样点');
title('原始信号和重构信号比较'); xlim([0 max(tt)]);
set(gcf,'color','w');

