%
% pr3_2_3 
clear all; close all; clc;

wp=[0.2*pi 0.3*pi];              % 设置通带频率
ws=[0.1*pi 0.4*pi];              % 设置阻带频率
Rp=1; Rs=20;                     % 设置波纹系数

% 巴特沃斯滤波器设计
[N,Wn]=buttord(wp,ws,Rp,Rs,'s'); % 求巴特沃斯滤波器阶数
fprintf('巴特沃斯滤波器 N=%4d\n',N) % 显示滤波器阶数
[bn,an]=butter(N,Wn,'s');        % 求巴特沃斯滤波器系数
W1=Wn(1); W2=Wn(2);              % 设置W1,W2
Wo=sqrt(W1*W2);
Bw=W2-W1;
[z,p,k]=buttap(N);               % 设计低通原型数字滤波器
[Bap,Aap]=zp2tf(z,p,k);          % 零点极点增益形式转换为传递函数形式
[bb,ab]=lp2bp(Bap,Aap,Wo,Bw);    % 低通滤波器频率转换
W=0:0.01:2;                      % 设置模拟频率
[Hn,wn]=freqs(bn,an,W);          % 求巴特沃斯滤波器频率响应
[Hb,wb]=freqs(bb,ab,W);          % 求巴特沃斯滤波器频率响应
% 作图
plot(wn/pi,20*log10(abs(Hn)),'r','linewidth',2)
hold on
plot(wb/pi,20*log10(abs(Hb)),'k')% 作图
title('两种编程方法设计巴特沃斯带通滤波器');
xlabel('圆频率{\omega}/{\pi}'); ylabel('幅值/dB')
set(gcf,'color','w'); 
axis([0 max(wb/pi) -30 2]); 
legend('第1种编程方法','第2种编程方法')
line([0 max(wb/pi)],[-20 -20],'color','k','linestyle','--');
line([0 max(wb/pi)],[-1 -1],'color','k','linestyle','--');
line([0.2 0.2],[-30 2],'color','k','linestyle','--');
line([0.3 0.3],[-30 2],'color','k','linestyle','--');
