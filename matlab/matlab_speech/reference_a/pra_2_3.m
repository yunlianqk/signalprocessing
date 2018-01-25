%
% pra_2_3    
clear all; clc; close all

filedir=[];                               % 设置数据文件的路径
filename='deepstep.wav';                  % 设置数据文件的名称
fle=[filedir filename]                    % 构成路径和文件名的字符串
[xx,fs]=wavread(fle);                     % 读取文件
xx=xx-mean(xx);                           % 消除直流分量
xx=xx/max(abs(xx));                       % 幅值归一化
N=length(xx);                             % 信号长度
time = (0 : N-1)/fs;                      % 设置时间刻度
wlen=320;                                 % 帧长
inc=80;                                   % 帧移
overlap=wlen-inc;                         % 两帧重叠长度  
lmin=floor(fs/300);                       % 最高基音频率500Hz对应的基音周期
lmax=floor(fs/60);                        % 最高基音频率60Hz对应的基音周期 

yy=enframe(xx,wlen,inc)';                 % 第一次分帧
fn=size(yy,2);                            % 取来总帧数
frameTime = frame2time(fn, wlen, inc, fs);% 计算每一帧对应的时间
Thr1=0.1;                                 % 设置端点检测阈值
r2=0.5;                                   % 设置元音主体检测的比例常数
ThrC=[10 15];                             % 设置相邻基音周期间的阈值
% 用于基音检测的端点检测和元音主体检测
[voiceseg,vosl,vseg,vsl,Thr2,Bth,SF,Ef]=pitch_vads(yy,fn,Thr1,r2,6,5);
figure(1)
pos = get(gcf,'Position');
set(gcf,'Position',[pos(1), pos(2)-100,pos(3),pos(4)-120]);
subplot 211; plot(time,xx,'k');
title('原始信号波形图'); axis([0 max(time) -1 1]);
xlabel('(a)'); ylabel('幅值');
for k=1 : vosl
        line([frameTime(voiceseg(k).begin) frameTime(voiceseg(k).begin)],...
        [-1 1],'color','k');
        line([frameTime(voiceseg(k).end) frameTime(voiceseg(k).end)],...
        [-1 1],'color','k','linestyle','--');
end
subplot 212; plot(frameTime,Ef,'k'); hold on
title('能熵比图'); axis([0 max(time) 0 max(Ef)]);
xlabel(['时间/s' 10 '(b)']); ylabel('幅值');
line([0 max(frameTime)],[Thr1 Thr1],'color','k','linestyle','--');
plot(frameTime,Thr2,'k','linewidth',2);
for k=1 : vsl
        line([frameTime(vseg(k).begin) frameTime(vseg(k).begin)],...
        [0 max(Ef)],'color','k','linestyle','-.');
        line([frameTime(vseg(k).end) frameTime(vseg(k).end)],...
        [0 max(Ef)],'color','k','linestyle','-.');
end

% 60～500Hz的带通滤波器系数
b=[0.012280   -0.039508   0.042177   0.000000   -0.042177   0.039508   -0.012280];
a=[1.000000   -5.527146   12.854342   -16.110307   11.479789   -4.410179   0.713507];
x=filter(b,a,xx);                         % 数字滤波
x=x/max(abs(x));                          % 幅值归一化
y=enframe(x,wlen,inc)';                   % 第二次分帧

m=3;                                      % 取第3个元音主体
fprintf('m=%4d\n',m);                     % 显示
T1=corrbp_test12(y,fn,vseg,vsl,lmax,lmin,ThrC,m);

