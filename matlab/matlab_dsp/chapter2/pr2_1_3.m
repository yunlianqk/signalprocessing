%
% pr2_1_3 
clear all; clc; close all;

N=33;                           % 设置N长
x=zeros(1,N);                   % 构成矩形波形
x(7:27)=1;        
X=fft(x);                       % FFT
Y=zeros(1,17);                  % 初始化Y
Y(1:6)=X(1:6);                  % 设定只取1-6条谱线
Y1=fliplr(Y(2:end));            % 构成相应对称的谱线
Y=[Y conj(Y1)];                 % 构成共轭对称
y=ifft(Y);                      % FFT逆变换
n=1:N;
% 作图
subplot 211; plot(n,real(y),'k');
xlabel('样点'); ylabel('幅值'); 
title('x(n)实部')
subplot 212; plot(n,imag(y),'k');
xlabel('样点'); ylabel('幅值'); 
title('x(n)虚部')
set(gcf,'color','w');
