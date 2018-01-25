%
% pr3_7_2 
clear all; close all; clc;

fp=100; fs=200;                  % 设置通带和阻带
Fs=1000;                         % 采样频率
Rp=2; Rs=40;                     % 通带波纹和阻带衰减
wp=fp*2*pi/Fs;                   % 把通带和阻带设为角频率
ws=fs*2*pi/Fs;
T=1;                             % T=1
Ts=1/Fs;                         % Ts=1/Fs
Wp=2/Ts*tan(wp/2);               % 把通带和阻带按Fs进行预畸
Ws=2/Ts*tan(ws/2);
[N,Wn]=cheb1ord(Wp,Ws,Rp,Rs,'s');% 求原型模拟低通滤波器的阶数和带宽 
[bs,as]=cheby1(N,Rp,Wn,'s');     % 求模拟低通滤波器的系数
[B,A]=bilinear(bs,as,Fs);        % 按Fs把模拟低通滤波器的系数转换成数字滤波器
%显示滤波器系数
fprintf('B=%5.6f   %5.6f   %5.6f   %5.6f   %5.6f\n',B);
fprintf('A=%5.6f   %5.6f   %5.6f   %5.6f   %5.6f\n',A);
[H1,f1]=freqz(B,A,1000,Fs);      % 计算数字滤波器的响应曲线

Wp=2/T*tan(wp/2);                % 把通带和阻带按Fs=1进行预畸
Ws=2/T*tan(ws/2);
[N,Wn]=cheb1ord(Wp,Ws,Rp,Rs,'s');% 求原型模拟低通滤波器的阶数和带宽 
[bs,as]=cheby1(N,Rp,Wn,'s');     % 求模拟低通滤波器的系数
[B,A]=bilinear(bs,as,1);         % 按Fs=1把模拟低通滤波器的系数转换成数字滤波器
%显示滤波器系数
fprintf('B=%5.6f   %5.6f   %5.6f   %5.6f   %5.6f\n',B);
fprintf('A=%5.6f   %5.6f   %5.6f   %5.6f   %5.6f\n',A);
[H2,f2]=freqz(B,A,1000,Fs);      % 计算数字滤波器的响应曲线,恢复原采样频率
% 作图
subplot 211; plot(f1,20*log10(abs(H1)),'k','linewidth',2)
xlabel('频率/Hz'); ylabel('幅值/dB')
title('切比雪夫I型低通滤波器幅频响应(bilinear中Fs=1000)')
axis([0 300 -50 5]); %grid; 
line([100 100],[-50 5],'color','k','linestyle',':');
line([200 200],[-50 5],'color','k','linestyle',':');
line([0 300],[-40 -40],'color','k','linestyle','--');
line([0 300],[-2 -2],'color','k','linestyle','--');
[H2,f2]=freqz(B,A,1000,Fs);
subplot 212; plot(f2,20*log10(abs(H2)),'k','linewidth',2)
xlabel('频率/Hz'); ylabel('幅值/dB')
title('切比雪夫I型低通滤波器幅频响应(bilinear中Fs=1)')
axis([0 300 -50 5]); %grid; 
line([100 100],[-50 5],'color','k','linestyle',':');
line([200 200],[-50 5],'color','k','linestyle',':');
line([0 300],[-40 -40],'color','k','linestyle','--');
line([0 300],[-2 -2],'color','k','linestyle','--');
set(gcf,'color','w') 

