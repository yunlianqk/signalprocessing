%
% pr2_2_15 
clear all; clc; close all;

xx=load('delaydata1.txt');% 读入数据
x=xx(:,1);               % 设为x
y=xx(:,2);               % 设为y
N=length(x);             % 数据长度
[Rxy,lags]=xcorr(y,x);   % 用xcorr计算线性相关
% 快速计算线性相关
X=fft(x,2*N);            % FFT
Y=fft(y,2*N);            % FFT
Sxy=Y.*conj(X);
sxy=ifftshift(ifft(Sxy));% IFFT,调整序列排列
Cxy=sxy(2:end);          % 只取2*N-1点
% 作图
subplot 211; 
line([lags],[Rxy],'color',[.6 .6 .6],'linewidth',3); hold on
plot(lags,Cxy,'k'); axis([-100 100 -50 200]);
box on; title('(a) 两种方法得到x和y的线性相关')
xlabel('样点'); ylabel('相关函数幅值')
legend('xcorr','快速线性相关',2)
% 计算循环相关
Xc=fft(x);               % FFT
Yc=fft(y);               % FFT
Scxy=Yc.*conj(Xc);
scxy=ifftshift(ifft(Scxy));% IFFT,调整序列排列
Ccxy=scxy(2:end);        % 只取N-1点
lagc=-N/2+1:N/2-1;       % 设置延迟序列
% 作图
subplot 212; plot(lagc,Ccxy,'k'); 
axis([-100 100 -50 200]); title('(b) x和y的循环相关')
xlabel('样点'); ylabel('相关函数幅值')
set(gcf,'color','w')
