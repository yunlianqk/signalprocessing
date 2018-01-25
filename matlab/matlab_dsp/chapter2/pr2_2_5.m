%
% pr2_2_5 
clear all; clc; close all;

load qldata.mat                  % 读入数据
N=length(y);                     % 数据长度
time=(0:N-1)/fs;                 % 时间刻度
% 第一部分
Y=fft(y);                        % FFT
n2=1:N/2+1;                      % 取正频率索引序列
freq=(n2-1)*fs/N;                % 频率刻度
% 作图
subplot 211; plot(time,y,'k'); ylim([0 15]); grid;
title('有趋势项的数据')
xlabel('时间/s'); ylabel('幅值');
subplot 212; plot(freq,abs(Y(n2)),'k')
title('有趋势项的数据频谱')
xlabel('频率/Hz'); ylabel('幅值');
set(gcf,'color','w');
pause
% 第二部分
x=detrend(y);                    % 消除趋势项
X=fft(x);                        % FFT
% 作图
figure
subplot 211; plot(time,x,'k'); ylim([-5 5]); grid;
title('消除趋势项后的数据')
xlabel('时间/s'); ylabel('幅值');
subplot 212; plot(freq,abs(X(n2)),'k');
title('消除趋势项后的数据频谱')
xlabel('频率/Hz'); ylabel('幅值');
set(gcf,'color','w');


