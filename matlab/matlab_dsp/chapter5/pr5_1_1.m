%
% pr5_1_1 
clear all; clc; close all;

N=1024;                      % 数据长度
fs=1000;                     % 采样频率
tt=(0:N-1)/fs;               % 时间刻度
x1=chirp(tt,0,1,350);        % Chirp 信号x1
x2=chirp(tt,350,1,0);        % Chirp 信号x2
x=x1'+x2';                   % 两个Chirp 信号相加；
win=hanning(127);            % 窗函数
[B,t,f]=tfrstft(x,1:N,N,win);% 短时傅里叶变换
% 作图
figure(1)                    % 信号波形图
subplot 211; plot(tt,x1,'k');
title(' Chirp信号x1')
xlabel('时间/s'); ylabel('幅值')
xlim([0 max(tt)]);
subplot 212; plot(tt,x2,'k');
title(' Chirp信号x2')
xlabel('时间/s'); ylabel('幅值')
xlim([0 max(tt)]);
set(gcf,'color','w');
figure(2)                    % 用mesh作三维图
mesh(tt,f(1:N/2)*fs,abs(B(1:N/2,:)));
xlabel('时间/s'); ylabel('频率')
title('调频信号STFT的三维图')
axis([0 max(tt) 0 500 0 6]);
set(gcf,'color','w');
figure(3)                    % 用mesh作二维图
mesh(tt,f(1:N/2)*fs,abs(B(1:N/2,:)));
%mesh(tt,f*fs,abs(B));
view(0,90); xlim([0 max(tt)])
xlabel('时间/s'); ylabel('频率')
title('调频信号STFT的二维图')
set(gcf,'color','w');
figure(4)                    % 用contour作等高线图
contour(tt,f(1:N/2)*fs,abs(B(1:N/2,:)),256);
xlabel('时间/s'); ylabel('频率')
title('调频信号STFT的等高线图')
set(gcf,'color','w');
figure(5)                    % 用imagesc作二维图
imagesc(tt,f(1:N/2)*fs,abs(B(1:N/2,:))); axis xy
xlabel('时间/s'); ylabel('频率')
title('调频信号STFT的频谱图')
set(gcf,'color','w');









  