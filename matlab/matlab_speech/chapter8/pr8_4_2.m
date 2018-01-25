% 
% pr8_4_2 
clc; close all; clear all;

run Set_II;
run Part_II;

lmin=floor(fs/500);                              % 基音周期的最小值
lmax=floor(fs/60);                               % 基音周期的最大值
period=zeros(1,fn);                              % 基音周期初始化
T0=zeros(1,fn);                                  % 初始化
period=ACFAMDF_corr(y,fn,voiceseg,vosl,lmax,lmin);  % 提取基音周期
T0=pitfilterm1(period,voiceseg,vosl);            % 基音周期平滑处理
% 作图
subplot 211, plot(time,x,'k');  title('语音信号')
axis([0 max(time) -1 1]); grid;  ylabel('幅值'); xlabel('时间/s');
subplot 212; hold on
line(frameTime,period,'color',[.6 .6 .6],'linewidth',2); 
xlim([0 max(time)]); title('基音周期'); 
grid; xlabel('时间/s'); ylabel('样点数');
plot(frameTime,T0,'k'); hold off
legend('初估算值','平滑后值'); box on
