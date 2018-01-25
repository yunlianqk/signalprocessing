%
% pr3_13_1 
clear all; clc; close all

Fs=100;                          % 采样频率
Fs2=Fs/2;                        % 奈奎斯特频率
fp=3; fs=5;                      % 通带和阻带频率
Rp=3; As=50;                     % 通带波纹和阻带衰减
wp = fp*pi/Fs2; ws = fs*pi/Fs2;  % 通带和阻带归一化角频率
deltaw= ws - wp;                 % 过渡带宽Δω的计算
N = ceil(6.6*pi/ deltaw);        % 按海明窗计算所需的滤波器阶数N(按式(3-13-1))
N = N + mod(N,2);                % 保证滤波器系数长N+1为奇数
wind = (hamming(N+1))';          % 海明窗计算
Wn=(3+5)/100;                    % 计算截止频率
b=fir1(N,Wn,wind);               % 用fir1函数设计FIR第1类滤波器
[db,mag,phs,gdy,w]=freqz_m(b,1); % 计算滤波器响应
% 作图
subplot 211; plot(w*Fs/(2*pi),db,'k','linewidth',2);
title('(a)低通滤波器的幅值响应');
grid; axis([0 20 -70 10]); 
xlabel('频率/Hz');  ylabel('幅值/dB')
set(gca,'XTickMode','manual','XTick',[0,3,5,20])
set(gca,'YTickMode','manual','YTick',[-50,0])
subplot 212; stem(1:N+1,b,'k');
xlabel('频率/Hz');  ylabel('幅值/dB')
title('(b)低通滤波器的脉冲响应');
xlabel('样点');  ylabel('幅值')
axis([0 167 -0.05 0.1]); 
set(gca,'XTickMode','manual','XTick',[1,84,167])
set(gcf,'color','w');

