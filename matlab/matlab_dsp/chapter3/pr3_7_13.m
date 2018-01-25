%
% pr3_7_13 from bp1341
clear all; close all; clc;

fc=400;fb=600;                   % 设置通带和阻带频率
Rp=3;Rs=20;                      % 设置通带波纹和阻带衰减
Fs=4000; Fs2=Fs/2;               % 采样频率和奈奎斯特频率
Wp=fc/Fs2; Ws=fb/Fs2;            % 通带和阻带归一化频率
[N,Wn]=buttord(Wp,Ws,Rp,Rs);     % 设计巴特沃斯原型滤波器
[bn,an] = butter(N,Wn);          % 求出滤波器系数bn,an
[H1,w]=freqz(bn,an);             % 计算响应曲线
Hgd=grpdelay(bn,an);             % 计算群延迟曲线

F = 0:0.001:Wp;                  % 通带区间
g = grpdelay(bn,an,F,2);         % 求出通带群延迟
Gd = max(g)-g;                   % 给出一个反向群延迟值
% 设计一个IIR全通滤波器
[num,den,tau]=iirgrpdelay(4, F, [0 0.2], Gd);  

B=conv(num,bn);                  % 两滤波器级联后系数
A=conv(den,an);
[Ho,wo]=freqz(B,A);              % 计算级联滤波器响应曲线
[Hogd,wgd]=grpdelay(B,A);        % 计算级联滤波器群延迟曲线
% 作图
subplot 221; plot(w*Fs/2/pi,20*log10(abs(H1)),'k'); 
xlabel('频率/Hz'); ylabel('幅值/dB');
title('(a)巴特沃斯滤波器幅频响应'); axis([0 2000 -100 10]);

subplot 222; plot(w*Fs/2/pi,Hgd,'k'); xlim([0 2000]);
xlabel('频率/Hz率'); ylabel('延迟量/样点数');
title('(b)巴特沃斯滤波器群延迟')
subplot 223; plot(wo/pi*Fs2,20*log10(abs(Ho)),'k');
xlabel('频率/Hz'); ylabel('幅值/dB');
title('(c)级联滤波器幅频响应'); axis([0 2000 -100 10]);
subplot 224; plot(wgd/pi*Fs2,Hogd,'k');
xlabel('频率/Hz'); ylabel('延迟量/样点数');
title('(d)级联滤波器群延迟')
set(gcf,'color','w'); 