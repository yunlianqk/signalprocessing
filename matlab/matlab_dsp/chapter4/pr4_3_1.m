%
% pr4_3_1
clear all; clc; close all;

n=-5000:20:5000;            % 样点设置
% 程序第一部分:直接做做希尔伯特变换
N=length(n);                % 信号样点数
nt=0:N-1;                   % 设置样点序列号
x=120+96*exp(-(n/1500).^2).*cos(2*pi*n/600); % 设置信号
Hx=hilbert(x);              % 希尔伯特变换
% 作图
plot(nt,x,'k',nt,abs(Hx),'r');
grid; legend('信号','包络');
xlabel('样点'); ylabel('幅值')
title('信号和包络')
set(gcf,'color','w');
pause

% 程序第二部分:消除直流后做希尔伯特变换
y=x-120;                    % 消除直流分量
Hy=hilbert(y);              % 希尔伯特变换
% 作图
figure(2)
plot(nt,y,'k',nt,abs(Hy),'r');
grid; legend('信号','包络');
xlabel('样点'); ylabel('幅值')
title('信号和包络')
set(gcf,'color','w');
figure(3);
plot(nt,x,'k',nt,abs(Hy)+120,'r');
grid; legend('信号','包络'); hold on;
xlabel('样点'); ylabel('幅值')
title('信号和包络')
set(gcf,'color','w');
pause

% 程序第三部分:通过频域做希尔伯特变换
y_fft=fft(y);               % FFT
y_hit(1)=y_fft(1);          % 按式(4-3-11)设置y_hit
y_hit(2:(N+1)/2)=2*y_fft(2:(N+1)/2);
y_hit((N+1)/2+1:N)=0;
z=ifft(y_hit);              % 对y_hit做IFFT
% 作图
figure(4)
subplot 211; plot(n,real(Hy),'r',n,real(z),'g');
xlabel('样点'); ylabel('幅值'); legend('时域','频域')
title('频域和时域希尔伯特变换实部比较');
subplot 212; plot(n,imag(Hy),'r',n,imag(z),'g');
xlabel('样点'); ylabel('幅值'); legend('时域','频域')
title('频域和时域希尔伯特变换虚部比较');set(gcf,'color','w');

figure(5)
plot(nt,x,'k',nt,abs(z)+120,'r');
grid; legend('信号','包络');
xlabel('样点'); ylabel('幅值')
title('信号和包络')
set(gcf,'color','w');

