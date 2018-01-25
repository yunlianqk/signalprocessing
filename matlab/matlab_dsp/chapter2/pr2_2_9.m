%
% pr2_2_9 
clear all; clc; close all;

fs=1000;                         % 采样频率
N=1000;                          % 信号长度
t=(0:N-1)/fs;                    % 设置时间序列
f1=50; f2=65.75;                 % 两信号频率
x=cos(2*pi*f1*t)+cos(2*pi*f2*t); % 设置信号
wind=hanning(N)';
X=fft(x.*wind);                  % 乘窗函数并FFT
Y=abs(X)*2/1000;                 % 计算幅值
freq=fs*(0:N/2)/1000;            % 设置频率刻度
[A1, k1]=max(Y(45:65));          % 寻求第1个信号的幅值
k1=k1+44;                        % 修正索引号
[A2, k2]=max(Y(60:70));          % 寻求第1个信号的幅值
k2=k2+59;                        % 修正索引号
Theta1=angle(X(k1));             % 计算信号f1的初始相角
Theta2=angle(X(k2));             % 计算信号f2的初始相角
Y1=Y*2;                          % 对加窗后的幅值进行修正
% 显示频率和幅值
fprintf('f1=%5.2f   A1=%5.4f   A11=%5.4f   Theta1=%5.4f\n',freq(k1),A1,A1*2,Theta1); 
fprintf('f2=%5.2f   A2=%5.4f   A21=%5.4f   Theta2=%5.4f\n',freq(k2),A2,A2*2,Theta2);

% 作图
subplot 211; plot(freq,Y(1:N/2+1),'k'); xlim([40 75]); 
line([0 100],[.5 .5],'color','k');
xlabel('频率/Hz'); ylabel('幅值'); title('(a)频谱图-幅值修正前');
subplot 212; plot(freq,Y1(1:N/2+1),'k'); xlim([40 75]); 
line([0 100],[1 1],'color','k');
xlabel('频率/Hz'); ylabel('幅值'); title('(b)频谱图-幅值修正后');
set(gcf,'color','w');

