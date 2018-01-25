% 
% pr8_3_1 
clc; close all; clear all;

run Set_II                                      % 参数设置
run Part_II                                     % 读入文件，分帧和端点检测
% 滤波器系数
b=[0.012280   -0.039508   0.042177   0.000000   -0.042177   0.039508   -0.012280];
a=[1.000000   -5.527146   12.854342   -16.110307   11.479789   -4.410179   0.713507];
xx=filter(b,a,x);                               % 带通数字滤波
yy  = enframe(xx,wlen,inc)';                    % 滤波后信号分帧

lmin=fix(fs/500);                               % 基音周期的最小值
lmax=fix(fs/60);                                % 基音周期的最大值
period=zeros(1,fn);                             % 基音周期初始化
period=ACF_corr(yy,fn,voiceseg,vosl,lmax,lmin); % 用自相关函数提取基音周期
T0=pitfilterm1(period,voiceseg,vosl);           % 平滑处理
% 作图
subplot 211, plot(time,x,'k');  title('语音信号')
axis([0 max(time) -1 1]); grid;  ylabel('幅值');
subplot 212; plot(frameTime,T0,'k'); hold on;
xlim([0 max(time)]); title('平滑后的基音周期'); 
grid; xlabel('时间/s'); ylabel('样点数');
for k=1 : vosl
    nx1=voiceseg(k).begin;
    nx2=voiceseg(k).end;
    nxl=voiceseg(k).duration;
    fprintf('%4d   %4d   %4d   %4d\n',k,nx1,nx2,nxl);
    subplot 211
    line([frameTime(nx1) frameTime(nx1)],[-1 1],'color','k','linestyle','-');
    line([frameTime(nx2) frameTime(nx2)],[-1 1],'color','k','linestyle','--');
end
