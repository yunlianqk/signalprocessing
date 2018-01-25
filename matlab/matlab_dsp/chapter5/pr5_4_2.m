%
% pr5_4_2
clear all; clc; close all;

[x1,fs1]=wavread('PhoneNumberA_2013.wav'); % 读入PhoneNumberA_2013.wav
x1=x1-mean(x1);
B=goertzel_decode(x1,0.15);                % 应用Goertzel算法解码
fprintf('%s\n',B);                         % 显示解码出的字符串
N1=length(x1);                             % x1的长度
time1=(0:N1-1)/fs1;                        % x1的时间刻度

[x2,fs2]=wavread('PhoneNumberB_2013.wav'); % 读入PhoneNumberB_2013.wav
x2=x2-mean(x2);
B=goertzel_decode(x2,0.05);                % 应用Goertzel算法解码
fprintf('%s\n',B);                         % 显示解码出的字符串
N2=length(x2);                             % x1的长度
time2=(0:N2-1)/fs2;                        % x1的时间刻度
% 作图
subplot 211; plot(time1,x1,'k');
xlabel('时间/s'); ylabel('幅值'); 
title('PhoneNumberA-2013数据的波形图');
grid; xlim([0 max(time1)]);
subplot 212; plot(time2,x2,'k');
xlabel('时间/s'); ylabel('幅值'); 
title('PhoneNumber-2013数据的波形图');
grid; xlim([0 max(time2)]);
set(gcf,'color','w');



