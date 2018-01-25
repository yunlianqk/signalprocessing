%
% pr3_2_1
clear all; close all; clc;

wp=[0.2*pi 0.3*pi];              % 设置通带频率
ws=[0.1*pi 0.4*pi];              % 设置阻带频率
Rp=1; Rs=20;                     % 设置波纹系数

% 巴特沃斯滤波器设计
[N,Wn]=buttord(wp,ws,Rp,Rs,'s'); % 求巴特沃斯滤波器阶数
fprintf('巴特沃斯滤波器 N=%4d\n',N) % 显示滤波器阶数
[bb,ab]=butter(N,Wn,'s');        % 求巴特沃斯滤波器系数
W=0:0.01:2;                      % 设置模拟频率
[Hb,wb]=freqs(bb,ab,W);          % 求巴特沃斯滤波器频率响应
plot(wb/pi,20*log10(abs(Hb)),'b')% 作图
hold on

% 切比雪夫I型滤波器设计
[N,Wn]=cheb1ord(wp,ws,Rp,Rs,'s');  % 求切比雪夫I型滤波器阶数
fprintf('切比雪夫I型滤波器 N=%4d\n',N) % 显示滤波器阶数
[bc1,ac1]=cheby1(N,Rp,Wn,'s');     % 求切比雪夫I型滤波器系数
[Hc1,wc1]=freqs(bc1,ac1,W);        % 求切比雪夫I型滤波器频率响应
plot(wc1/pi,20*log10(abs(Hc1)),'k')% 作图

% 切比雪夫II型滤波器设计 
[N,Wn]=cheb2ord(wp,ws,Rp,Rs,'s');  % 求切比雪夫II型滤波器阶数
fprintf('切比雪夫II型滤波器 N=%4d\n',N) % 显示滤波器阶数
[bc2,ac2]=cheby2(N,Rs,Wn,'s');    % 求切比雪夫II型滤波器系数
[Hc2,wc2]=freqs(bc2,ac2,W);       % 求切比雪夫II型滤波器频率响应
plot(wc2/pi,20*log10(abs(Hc2)),'r')% 作图

% 椭圆型滤波器设计
[N,Wn]=ellipord(wp,ws,Rp,Rs,'s');  % 求椭圆型滤波器阶数
fprintf('椭圆型滤波器 N=%4d\n',N) % 显示滤波器阶数
[be,ae]=ellip(N,Rp,Rs,Wn,'s');     % 求椭圆型滤波器系数
[He,we]=freqs(be,ae,W);            % 求椭圆型滤波器频率响应
% 作图
plot(we/pi,20*log10(abs(He)),'g')
axis([0 max(we/pi) -30 2]); %grid;
legend('巴特沃斯滤波器','切比雪夫I型滤波器','切比雪夫II型滤波器','椭圆型滤波器')
xlabel('角频率{\omega}/{\pi}'); ylabel('幅值/dB')
set(gcf,'color','w'); 

line([0 max(we/pi)],[-20 -20],'color','k','linestyle','--');
line([0 max(we/pi)],[-1 -1],'color','k','linestyle','--');
line([0.2 0.2],[-30 2],'color','k','linestyle','--');
line([0.3 0.3],[-30 2],'color','k','linestyle','--');

