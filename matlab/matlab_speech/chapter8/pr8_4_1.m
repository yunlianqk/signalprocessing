% 
% pr8_4_1 
clc; close all; clear all;

run Set_II;                                     % 参数设置
run Part_II;                                    % 读入文件,分帧和端点检测
% 滤波器系数
b=[0.012280   -0.039508   0.042177   0.000000   -0.042177   0.039508   -0.012280];
a=[1.000000   -5.527146   12.854342   -16.110307   11.479789   -4.410179   0.713507];
xx=filter(b,a,x);                               % 带通数字滤波
yy  = enframe(xx,wlen,inc)';                    % 滤波后信号分帧

lmin=floor(fs/500);                             % 基音周期的最小值
lmax=floor(fs/60);                              % 基音周期的最大值
period=zeros(1,fn);                             % 基音周期初始化
period=AMDF_mod(yy,fn,voiceseg,vosl,lmax,lmin); % 用AMDF_mod函数提取基音周期
T0=pitfilterm1(period,voiceseg,vosl);           % 基音周期平滑处理
% 作图
subplot 211, plot(time,x,'k');  title('语音信号')
axis([0 max(time) -1 1]); grid;  ylabel('幅值'); xlabel('时间/s');
subplot 212; hold on
line(frameTime,period,'color',[.6 .6 .6],'linewidth',2); 
axis([0 max(time) 0 120]); title('基音周期'); 
grid; xlabel('时间/s'); ylabel('样点数');
subplot 212; plot(frameTime,T0,'k'); hold off
legend('初估算值','平滑后值'); box on;
