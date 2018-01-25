%
% pr2_1_4 
clear all; clc; close all;

fs = 2000;                      % 采样频率
N = 40;                         % 信号长度
n = 0:N-1;                      % 样点序列
f0 = 100; ph1=-pi/3;            % 初始频率和初始相角
x=cos(2*pi*f0*n/fs+ph1);        % 余弦信号序列
x1=hilbert(x);                  % 进行hilbert变换
X=fft(x1);                      % FFT
d = ph1*fs/f0/(2*pi);           % 计算位移量
Ex=exp(-1j*2*pi*n*d/N);         % 计算旋转因子W^(dk) 
Y = X.*Ex;                      % FFT后乘旋转因子
y=ifft(Y);                      % FFT逆变换
y1=real(y);                     % 取的实部
Y1=fft(y1);                     % FFT
df = fs/N;                      % 计算频率间隔
nk=f0/df+1;                     % 信号在nk谱线上
A=abs(real(Y1(nk)))*2/N;        % 计算幅值
Theta=angle(Y1(nk));            % 计算初始相角
fprintf('A=%5.2f   Theta=%5.6f\n',A,Theta)
% 作图
subplot 211; plot(n,x,'k'); 
axis([0 N -1.1 1.1]); 
title('原始信号'); ylabel('幅值'); xlabel('样点'); 
subplot 212; plot(n,y1,'k'); 
axis([0 N -1.1 1.1]); 
title('位移后信号的实部'); ylabel('幅值'); xlabel('样点'); 
set(gcf,'color','w')



