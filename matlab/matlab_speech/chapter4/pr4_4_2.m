%
% pr4_4_2 
clear all; clc; close all;

[x1,fs]=wavread('s1.wav');      % 读入信号s1
x2=wavread('s2.wav');           % 读入信号s2
x3=wavread('a1.wav');           % 读入信号a1
wlen=200;                       % 帧长
inc=80;                         % 帧移
x1=x1/max(abs(x1));             % 幅值归一化
x2=x2/max(abs(x2));
x3=x3/max(abs(x3));
p=12;                           % LPC阶数

[DIST12,y1lpcc,y2lpcc]=lpcc_dist(x1,x2,wlen,inc,p);% 计算x1与x2的LPCC距离
[DIST13,y1lpcc,y3lpcc]=lpcc_dist(x1,x3,wlen,inc,p);% 计算x1与x3的LPCC距离
% 作图
figure(1)
plot(y1lpcc(3,:),y2lpcc(3,:),'k+'); hold on
plot(y1lpcc(7,:),y2lpcc(7,:),'kx'); 
plot(y1lpcc(12,:),y2lpcc(12,:),'k^');
plot(y1lpcc(16,:),y2lpcc(16,:),'kh'); 
legend('第3帧','第7帧','第12帧','第16帧',2)
title('/i1/与/i2/之间的LPCC参数匹配比较')
xlabel('信号x1');ylabel('信号x2')
axis([-6 6 -6 6]);
line([-6 6],[-6 6],'color','k','linestyle','--');

figure(2)
plot(y1lpcc(3,:),y3lpcc(3,:),'k+'); hold on
plot(y1lpcc(7,:),y3lpcc(7,:),'kx'); 
plot(y1lpcc(12,:),y3lpcc(12,:),'k^');
plot(y1lpcc(16,:),y3lpcc(16,:),'kh'); 
legend('第3帧','第7帧','第12帧','第16帧',2)
title('/i1/与/a1/之间的LPCC参数匹配比较')
xlabel('信号x1');ylabel('信号x3')
axis([-6 6 -6 6]);
line([-6 6],[-6 6],'color','k','linestyle','--');

