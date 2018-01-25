%
% pr2_1_5   
clear all; clc; close all;

fs = 2000;                      % 采样频率
N = 40;                         % 信号长度
n = 0:N-1;                      % 样点序列
f0 = 100; ph1=-pi/3;            % 初始频率和初始相角
x=cos(2*pi*f0*n/fs+ph1);        % 余弦信号序列
X=fft(x);                       % FFT
d = ph1*fs/f0/(2*pi);           % 计算位移量
Ex=exp(-1j*2*pi*n*d/N);         % 计算旋转因子W^(-dk) 
X1 = X.*Ex;                     % FFT后乘旋转因子
X1 = X1(1:N/2+1);               % 取正频率部分
Y = [X1 conj(X1(end-1:-1:2))];  % 构成共轭对称
y=ifft(Y);                      % FFT逆变换
y1=real(y);                     % 取y的实部
df = fs/N;                      % 计算频率间隔
nk=floor(f0/df)+1;              % 信号在nk谱线上
Y1=fft(y1);                     % 对y1做FFT
A=abs(real(Y1(nk)))*2/N;        % 计算y1幅值
Theta=angle(Y1(nk));            % 计算y1初始相角
fprintf('A=%5.2f   Theta=%5.6f\n',A,Theta)
% 作图
subplot 311; plot(n,x,'k'); 
axis([0 N -1.1 1.1]); 
title('原始信号'); ylabel('幅值');
subplot 312; plot(n,real(y),'k'); 
axis([0 N -1.1 1.1]); 
title('位移后信号y的实部'); ylabel('幅值'); 
subplot 313; plot(n,imag(y),'k');
title('位移后信号y的虚部'); ylabel('幅值'); xlabel('样点'); 
set(gcf,'color','w')


