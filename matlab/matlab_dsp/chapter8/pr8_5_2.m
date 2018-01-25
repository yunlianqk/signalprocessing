%
% pr8_5_2 
clear all; clc; close all;

randn('state',0);                  % 随机数初始化
h = ones(1,10)/10;                 % 滤波器1系数
h1 = fir1(30,0.2,rectwin(31));     % 滤波器2系数
r = randn(16384,1);                % 产生随机数
x = filter(h,1,r);                 % 产生第1路信号x
y = filter(h1,1,r);                % 产生第2路信号y

N=length(x);                       % 数据点长度
[H,wh]=freqz(h,1);                 % 滤波器1的响应函数
[H1,wh1]=freqz(h1,1);              % 滤波器2的响应函数

wind=hamming(1024);                % 设置海明窗,窗长1024
noverlap=512;                      % 重叠长度
Nfft=1024;                         % FFT变换长度
PY1=pwelch(x,wind,noverlap,Nfft);  % 求第1路信号自谱
PY2=pwelch(y,wind,noverlap,Nfft);  % 求第2路信号自谱
[CY12,w1]=cpsd(x,y,wind,noverlap,Nfft);   % 求第1路和第2路信号的互谱
Co12=abs(CY12).^2./(PY1.*PY2);     % 按(8-5-5)计算相干函数
[CR,w2]=mscohere(x,y,wind,noverlap,Nfft); % 调用mscohere函数计算相干函数
mcof=max(abs(Co12-CR))             % 求两种方法的差值
% 作图
figure(1)
subplot 211; plot(x,'k'); title('第1路信号x波形');
ylabel('幅值'); xlabel('样点'); axis([0 N -1.2 1.2]);
subplot 212; plot(y,'k'); title('第2路信号y波形');
ylabel('幅值'); xlabel('样点'); axis([0 N -1.2 1.2]);
set(gcf,'color','w'); 
figure(2)
subplot 211; plot(wh/pi,20*log10(abs(H)),'k'); grid;
ylim([-60 10]); title('滤波器1幅值响应曲线');
ylabel('幅值/dB'); xlabel('归一化频率/pi');
subplot 212; plot(wh1/pi,20*log10(abs(H1)),'k'); grid;
ylim([-70 10]); title('滤波器2幅值响应曲线');
ylabel('幅值/dB'); xlabel('归一化频率/pi');
set(gcf,'color','w'); 
figure(3)
plot(w1/pi,Co12,'r','linewidth',2);
hold on; grid;
plot(w2/pi,CR,'k');
legend('调用自谱和互谱','调用mscohere',3)
title('两种方法求得相干函数比较');
ylabel('幅值'); xlabel('归一化频率/pi');
set(gcf,'color','w'); 

