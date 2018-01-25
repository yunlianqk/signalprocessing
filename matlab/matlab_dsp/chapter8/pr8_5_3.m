%
% pr8_5_3
clear all; clc; close all;

load seismicdata.mat         % 读入数据
N=length(x);                 % 数据长度
time=(0:N-1)/fs;             % 时间刻度

M=1024;                      % 窗长
noverlap=M/2;                % 重叠长度
w=hanning(M);                % 选用hanning窗
nfft=1024;                   % FFt的变换长度
[cxy,fxy]=mscohere(x,y,w,noverlap,nfft,fs);    % 计算相干函数值 
% 作图
figure(1)
subplot 211; plot(time,x,'k'); xlim([0 max(time)]);
title('地震信号第1通道x的波形图');
xlabel('时间/s'); ylabel('幅值')
subplot 212; plot(time,y,'k'); xlim([0 max(time)]);
title('地震信号第2通道y的波形图');
xlabel('时间/s'); ylabel('幅值')
set(gcf,'color','w'); 

figure(2)
plot(fxy,cxy,'k');
title(['M=' num2str(M) '相干函数谱线图']);
xlabel('频率/Hz'); ylabel('相干函数'); xlim([0 fs/2]);
set(gcf,'color','w'); 
