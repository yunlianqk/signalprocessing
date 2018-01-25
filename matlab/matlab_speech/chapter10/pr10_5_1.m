%
%  pr10_5_1 
clear all; clc; close all;

F0 = [700 900 2600];
Bw = [130 70 160];
fs=8000;

[An,Bn]=formant2filter4(F0,Bw,fs);    % 调用函数求取滤波器系数
for k=1 : 4                           % 对四个二阶带通滤波器做频响曲线
    A=An(:,k);                        % 取得滤波器系数
    B=Bn(k);
    fprintf('B=%5.6f   A=%5.6f   %5.6f   %5.6f\n',B,A);
    [H(:,k),w]=freqz(B,A);            % 求得响应曲线
end
freq=w/pi*fs/2;                       % 频率轴刻度
% 作图
plot(freq,abs(H(:,1)),'k',freq,abs(H(:,2)),'k',freq,abs(H(:,3)),'k',freq,abs(H(:,4)),'k');
axis([0 4000 0 1.05]); grid;
line([F0(1) F0(1)],[0 1.05],'color','k','linestyle','-.');
line([F0(2) F0(2)],[0 1.05],'color','k','linestyle','-.');
line([F0(3) F0(3)],[0 1.05],'color','k','linestyle','-.');
line([3500 3500],[0 1.05],'color','k','linestyle','-.');
title('三个共振峰和一个固定频率的二阶带通滤波器响应曲线')    
ylabel('幅值'); xlabel('频率/Hz')
    