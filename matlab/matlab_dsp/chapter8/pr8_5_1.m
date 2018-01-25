%
% pr8_5_1 
clear all; clc; close all;

load arcoeff.mat             % 读入AR系统系数  
N=1000;                      % 设置数据长
x=randn(1,N);                % 产生随机数,输入序列
fs=1000;                     % 采样频率
y=filter(1,ar,x);            % 系统输出序列
nfft=512;                    % 段长,也是FFT长
noverlap=nfft-1;             % 重叠长度
wind=hanning(nfft);          % 窗函数
% 调用tfestimate函数计算系统传递函数
[Txy,F]=tfestimate(x,y,wind,noverlap,nfft,fs);
[H,f]=freqz(1,ar,[],fs);     % 给出传递函数理论值
% 作图
figure
plot(f,abs(H),'r','linewidth',3); hold on
plot(F,abs(Txy),'k'); grid;
title('freqz与tfestimate结果的比较' );
xlabel('频率/Hz'); ylabel('幅值');
legend('理论值','由tfestimate计算得')
set(gcf,'color','w'); 







