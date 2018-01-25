%
% pr10_7_1 
clear all; clc; close all;

filedir=[];                                % 设置数据文件的路径
filename='bluesky3.wav';                   % 设置数据文件的名称
fle=[filedir filename]                     % 构成路径和文件名的字符串
[xx,fs]=wavread(fle);                      % 读取文件
xx=xx-mean(xx);                            % 去除直流分量
x=xx/max(abs(xx));                         % 归一化
N=length(x);                               % 数据长度
time=(0:N-1)/fs;                           % 求出对应的时间序列

[LowPass] = LowPassFilter(x, fs, 500);     % 低通滤波
p = PitchEstimation(LowPass, fs);		   % 计算基音频率
[u, v] = UVSplit(p);                       % 求出有话段和无话段信息
lu=size(u,1); lv=size(v,1);                % 初始化

pm = [];
ca = [];
for i = 1 : length(v(:,1))
    range = (v(i, 1) : v(i, 2));           % 取一个有话段信息
    in = x(range);                         % 取有话段数据
% 对一个有话段寻找基音脉冲标注
    [marks, cans] = VoicedSegmentMarking(in, p(range), fs);

    pm = [pm  (marks + range(1))];         % 保存基音脉冲标注位置
    ca = [ca;  (cans + range(1))];         % 保存基音脉冲标注候选名单
end
% 作图
figure(1)
pos = get(gcf,'Position');
set(gcf,'Position',[pos(1), pos(2)-150,pos(3),pos(4)+100]);
subplot 211; plot(time,x,'k'); axis([0 max(time) -1 1.2]);
for k=1 : lv
    line([time(v(k,1)) time(v(k,1))],[-1 1.2 ],'color','k','linestyle','-')
    line([time(v(k,2)) time(v(k,2))],[-1 1.2 ],'color','k','linestyle','--')
end
title('语音信号波形和端点检测');
xlabel(['时间/s' 10 '(a)']); ylabel('幅值');
%figure(2)
%pos = get(gcf,'Position');
%set(gcf,'Position',[pos(1), pos(2)-100,pos(3),(pos(4)-160)]);
subplot 212; plot(x,'k'); axis([0 N -1 0.8]);
line([0 N],[0 0],'color','k')
lpm=length(pm);
for k=1 : lpm
    line([pm(k) pm(k)],[0 0.8],'color','k','linestyle','-.')
end
xlim([3000 4000]);
title('部分语音信号波形和相应基音脉冲标注');
xlabel(['样点' 10 '(b)']); ylabel('幅值');


