%
% pr2_2_6 
clear all; clc; close all;

load sndata1.mat            % 读入数据
X=fft(y);                   % FFT
n2=1:L/2+1;                 % 计算正频率索引号
freq=(n2-1)*fs/L;           % 频率刻度
% 第一部分
% 线性幅值作图
pos = get(gcf,'Position');
set(gcf,'Position',[pos(1), pos(2)-100,pos(3),(pos(4)-140)]);
plot(freq,abs(X(n2)),'k'); grid
xlabel('频率/Hz'); ylabel('幅值')
title('线性幅值')
set(gcf,'color','w');
pause
% 第二部分
% 用对数坐标作图
figure
pos = get(gcf,'Position');
set(gcf,'Position',[pos(1), pos(2)-100,pos(3),(pos(4)-140)]);
semilogy(freq,abs(X(n2)),'k'); grid;
xlabel('频率/Hz'); ylabel('幅值')
title('对数坐标幅值'); hold on
set(gcf,'color','w');
% 计算分贝值作图
figure
X_db=20*log10(abs(X(n2)));
pos = get(gcf,'Position');
set(gcf,'Position',[pos(1), pos(2)-100,pos(3),(pos(4)-140)]);
plot(freq,X_db,'k'); grid;
xlabel('频率/Hz'); ylabel('幅值/dB')
title('分贝幅值'); hold on
set(gcf,'color','w');


