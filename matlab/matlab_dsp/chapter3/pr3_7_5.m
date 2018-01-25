%
% pr3_7_3 
clear all; clc; close all;

load jandatas.mat              % 导入数据
N1=length(z);                  % 原始数据长
Fsm=1;                         % 原始采样频率1分钟1样点 
y=resample(z,Fsm,60);          % 降采样60倍
N=length(y);                   % 降采样后的长度
hour=0:N-1;

Fsh=1;                         % 降采样后采样频率1小时1样点 
fp=[0.05 0.1];                 % 通带频率
fs=[0.025 0.15];               % 阻带频率
Ap=1; As=50;                   % 通带波纹和阻带衰减
Wp=fp*2/Fsh; Ws=fs*2/Fsh;      % 归一化通带和阻带频率
[M,Wn]=cheb2ord(Wp,Ws,Ap,As);  % 求滤波器原型阶数和带宽
[bn,an]=cheby2(M,As,Wn);       % 求数字滤波器系数
[H,f]=freqz(bn,an,1000,1);     % 求数字滤波器幅频曲线

x=filter(bn,an,y);             % 对降采样后的数据进行滤波
xx=resample(x,60,1);           % 对滤波器输出恢复原采样频率
xx=xx(1:N1);                   % 求取与输入序列相同长度和单位
% 作图
figure(1)
plot(f,20*log10(abs(H)),'k');
axis([0 0.2 -70 10]);  grid;
title('椭圆型滤波器幅频响应曲线');
xlabel('时间/小时'); ylabel('幅值/dB');
set(gcf,'color','w');
figure(2)
subplot 211; plot(hour,y,'k');
xlim([0 max(hour)]);
title('降采样后的数据'); xlabel('时间/小时'); 
subplot 212; plot(minute/10000,xx,'k');
title('滤波后周期为10-20小时的数据');xlabel('时间/万分钟'); 
set(gcf,'color','w');

