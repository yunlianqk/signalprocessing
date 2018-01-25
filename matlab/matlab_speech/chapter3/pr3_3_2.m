%
% pr3_3_2 
clear all; clc; close all;

[x1,fs]=wavread('s1.wav');      % 读入信号s1-\i1\
x2=wavread('s2.wav');           % 读入信号s2-\i2\
x3=wavread('a1.wav');           % 读入信号a1-\a1\
wlen=200;                       % 帧长
inc=80;                         % 帧移
x1=x1/max(abs(x1));             % 幅值归一化
x2=x2/max(abs(x2));
x3=x3/max(abs(x3));
% 计算/i1/与/i2/之间的匹配比较
[Dcep,Ccep1,Ccep2]=mel_dist(x1,x2,fs,16,wlen,inc);
figure(1)
plot(Ccep1(3,:),Ccep2(3,:),'k+'); hold on
plot(Ccep1(7,:),Ccep2(7,:),'kx'); 
plot(Ccep1(12,:),Ccep2(12,:),'k^');
plot(Ccep1(16,:),Ccep2(16,:),'kh'); 
legend('第3帧','第7帧','第12帧','第16帧',2)
xlabel('信号x1');ylabel('信号x2')
axis([-12 12 -12 12]);
line([-12 12],[-12 12],'color','k','linestyle','--');
title('/i1/与/i2/之间的MFCC参数匹配比较')

% 计算/i1/与/a1/之间的匹配比较
[Dcep,Ccep1,Ccep2]=mel_dist(x1,x3,fs,16,wlen,inc);
figure(2)
plot(Ccep1(3,:),Ccep2(3,:),'k+'); hold on
plot(Ccep1(7,:),Ccep2(7,:),'kx'); 
plot(Ccep1(12,:),Ccep2(12,:),'k^');
plot(Ccep1(16,:),Ccep2(16,:),'kh'); 
legend('第3帧','第7帧','第12帧','第16帧',2)
xlabel('信号x1');ylabel('信号x3')
axis([-12 12 -12 12]);
line([-12 12],[-12 12],'color','k','linestyle','--');
title('/i1/与/a1/之间的MFCC参数匹配比较')
