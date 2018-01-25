%
% pr3_7_1 
clear all; clc; close all;

bs=[1,1];as=[1,5,6];            % 系统分子分母系数向量
Fs=10; T=1/Fs;                  % 采样频率和采样间隔
[Ra,pa,ha]=residue(bs, as);	    % 将模拟滤波器系数向量变为模拟极点和留数
pd=exp(pa*T);			        % 将模拟极点变为数字（z平面）极点pd
[bd,ad]=residuez(T*Ra, pd, ha);	% 用原留数Ra和数字极点pd求得数字滤波器系数
t=0:0.1:3;                      % 时间序列
ha=impulse(bs,as,t);            % 计算模拟系统的脉冲响应
hd=impz(bd,ad,31);              % 数字系统的脉冲响应
% 调用impinvar函数计算数字滤波器系数
[Bd,Ad]=impinvar(bs,as,Fs);
fprintf('bd=%5.4f   %5.4f   ad=%5.4f   %5.4f   %5.4f\n\n',bd,ad);
fprintf('Bd=%5.4f   %5.4f   Ad=%5.4f   %5.4f   %5.4f\n',Bd,Ad);
% 作图
plot(t,ha*T,'r','linewidth',3); hold on; grid on;
plot(t,hd,'k');
legend('模拟滤波器脉冲响应','数字滤波器脉冲响应');
xlabel('时间/s'); ylabel('幅值/dB');
title('原模拟滤波器的脉冲响应与数字滤波器的脉冲响应比较')
set(gcf,'color','w')            

