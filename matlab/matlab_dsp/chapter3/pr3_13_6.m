%  
% pr3_13_6  
clear all; clc; close all;

Fs=2000;                                    % 采样频率
Fs2=Fs/2;                                   % 奈奎斯特频率
fc1=150; fc2=250; fc3=350;                  % 各频点的频率值
fc4=500; fc5=600; fc6=700;                  
fd=[0 fc1 fc2 fc3 fc4 fc5 fc6 800 Fs2]/Fs2;	% 各频率点构成频率矢量
Hd=[0 1 1 0.5 0.5 0.25 0.25 0 0];			% 对应各频点的理想幅值
dw=(fc3-fc2)*pi/Fs2;                        % 求出过渡带宽 
N=ceil(11*pi/dw);                           % 计算滤波器阶数 
wind=blackman(N+1)';                        % 布莱克曼窗函数 
hn=fir2(N, fd, Hd, wind);				    % 用fir2函数义滤波器系数
[H, f] = freqz(hn, 1, 512, Fs);			    % 求滤波器的响应
% 作图
plot(f, abs(H),'k','linewidth',2), 
xlabel('频率/Hz'); ylabel('幅值');
title('一个频域阶梯形权函数的幅值响应曲线')
set(gca,'XTickMode','manual','XTick',[0,150,250,350,500,600,700,800])
set(gca,'YTickMode','manual','YTick',[0.25,0.5,1])
grid on; ylim([0 1.2]);
set(gcf,'color','w');

