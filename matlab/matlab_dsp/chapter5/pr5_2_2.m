%
% pr5_2_2 
clear all; clc; close all;

fs=2048;                         % 采样频率
nfft=1024;                       % FFT变换长度
fk=[50 150 496 498 500 502 505]; % 频率矩阵
A=[220 35 1 1 1 1 1];            % 幅值矩阵
D=100;                           % 细化倍数
a=0.3;                           % 外扩系数
L=nfft*D+round(8*D/a);           % 数据长度
t=(0:L-1)/fs;                    % 时间刻度
x=zeros(1,L);                    % 初始化
for k=1 : 7                      % 构成信号
    x=x+A(k)*cos(2*pi*fk(k)*t);
end
fe=500;                          % 细化区间中心频率
[xz,f]=zoomffta(x,fs,nfft,fe,D,a);  % 复解析滤波器复调制细化分析
% 作图
subplot 211; plot(t,x,'k'); xlim([0 0.5]);
xlabel('时间/s'); ylabel('幅值')
title('信号时域波形');
subplot 212; plot(f,abs(xz),'k','linewidth',1.5); 
set(gca, 'XTickMode', 'manual', 'XTick', [495,496,498,500,502,504,505,506]);
grid; ylim([0 1.2]);
xlabel('频率/Hz'); ylabel('幅值')
title('密集间谐波的分析');
set(gcf,'color','w');

