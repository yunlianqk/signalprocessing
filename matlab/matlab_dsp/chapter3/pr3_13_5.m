%
% pr3_13_5 
clear all; clc; close all;

% 信号构成
N=100;                                    % 数据长
Fs=100;                                   % 采样频率
Fs2=Fs/2;                                 % 奈奎斯特频率
f1=5; f2=20;                              % 两正弦信号频率
phy1=pi/4; phy2=pi/3;                     % 两正弦信号初始相位角
t=(0:N-1)/Fs;                             % 时间刻度
x=cos(2*pi*f1*t+phy1)+cos(2*pi*f2*t+phy2);% 构成输入信号 
% FIR低通滤波器设计
fp=10; fs=15;                             % 通带和阻带频率
Rp=3; As=60;                              % 通带波纹和阻带衰减
wp=fp*pi/Fs2; ws=fs*pi/Fs2;               % 归一化角频率
deltaw= ws - wp;                          % 过渡带宽Δω的计算
M = ceil(11*pi/ deltaw);                  % 按布莱克曼窗计算滤波器阶数M
M = M + mod(M,2);                         % 保证滤波器系数长M+1为奇数
wind = (blackman(M+1))';                  % 布莱克曼窗函数
Wn=(fp+fs)/Fs;                            % 计算截止频率
b=fir1(M,Wn,wind);                        % 用fir1函数设计FIR第1类滤波器
[db,mag,phs,gdy,w]=freqz_m(b,1);          % 计算滤波器响应
% 信号滤波
y1=filter(b,1,x);                         % 用filter函数进行滤波
y2=conv(b,x);                             % 用conv函数进行滤波
y21=y2(M/2+1:M/2+N);                      % 取y2中的有效部分
N2=length(y2);                            % 求y2长度
t2=(0:N2-1)/Fs;                           % y2的时间刻度
% 作图
figure(1)
pos = get(gcf,'Position');
set(gcf,'Position',[pos(1), pos(2)-100,pos(3),(pos(4)-160)]);
plot(w/pi*Fs2,db,'k')
title('低通滤波器的幅值响应');
grid; axis([0 Fs2 -150 10]); 
xlabel('频率/Hz');  ylabel('幅值/dB')
set(gca,'XTickMode','manual','XTick',[0,10,15,20,50])
set(gca,'YTickMode','manual','YTick',[-100,-60,0])
set(gcf,'color','w');
figure(2)
subplot 311; plot(t,y1,'k');
ylim([-1.1 1.1]);
title('(a)通过filter函数FIR滤波器的输出');
xlabel('时间/s'); ylabel('幅值')
subplot 312; plot(t2,y2,'k');
ylim([-1.1 1.1]);
title('(b)通过conv函数FIR滤波器的输出');
xlabel('时间/s'); ylabel('幅值')
subplot 313; plot(t,y21,'k');
ylim([-1.1 1.1]);
title('(c)对(b)的输出进行修正');
xlabel('时间/s'); ylabel('幅值')
set(gcf,'color','w');


