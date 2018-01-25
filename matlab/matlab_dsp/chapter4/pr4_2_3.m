%
% pr4_2_3 
clear all; clc; close all;

[xx,fs]=wavread('sch32.wav');     % 读入数据和采样频率
x=xx(:,1);                        % 双声道数据分别设定为x和y
y=xx(:,2);
N = length(x);                    % 信号长度
n=0:N-1;                          % 序列号
[R,lags]=xcorr(y,x);              % 计算y和x的互相关函数
[Rmax,K]=max(R);                  % 在R中找最大值和相应位置
lagk=lags(K);
fprintf('lagk=%4d   Rmax=%5.4f\n',lagk,Rmax);  % 显示内插前最大延迟量和幅值
[Locs,Val]=findpeakm(R,'q',35);   % 用findpeakm函数寻找相关函数中的峰值
Locs=Locs-N;                      % 修正Logs
fprintf('Mmax=%5.4f   Rmax=%5.4f\n',Locs(9),Val(9)); % 显示最大延迟量和幅值
% 作图
subplot 211; plot(n,x,'k');
xlabel('样点'); ylabel('幅值'); 
title('信号x波形图'); xlim([0 N]);
subplot 212; plot(n,y,'k');
xlabel('样点'); ylabel('幅值'); 
title('信号y波形图'); xlim([0 N]);
set(gcf,'color','w');
figure
subplot 211; plot(lags,R,'k'); grid; hold on;
plot(Locs,Val,'ro');
axis([min(lags) max(lags) -25 45])
xlabel('延迟量/样点'); ylabel('相关函数幅值'); 
title('相关函数曲线图');
subplot 212; plot(lags,R,'k'); grid; hold on
plot(Locs,Val,'ro');
axis([-20 20 -25 45]);
xlabel('延迟量/样点'); ylabel('相关函数幅值'); 
title('相关函数曲线图(最大值)');
set(gcf,'color','w');



