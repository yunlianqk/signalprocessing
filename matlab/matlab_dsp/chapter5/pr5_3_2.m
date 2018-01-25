%
% pr5_3_2 
clear all; clc; close all;

fs=2048;                     % 采样频率
N=1024;                      % 信号长度
df1=fs/N;                    % 分辨率
n=1:N;                       % 样点索引
t=(n-1)/fs;                  % 时间序列
f1=431.1; f2=432.2; f3=433.3; % 信号频率
% 构成信号序列
s=3*cos(2*pi*f1*t)+4*cos(2*pi*f2*t+0.2)+5*cos(2*pi*f3*t+0.4);
wind=hanning(N)';            % 窗函数
S=abs(fft(s.*wind))*4/N;     % FFT并求幅值
n1=1:N/2;                    % 正频率部分
% CZT
f0=428; DELf=0.01; M=N;      % 设置CZT的参数f0,DELf和M
n2=f0:DELf:f0+(M-1)*DELf;    % 设置CZT中的频率区间
A=exp(1j*2*pi*f0/fs);        % 设置A和W
W=exp(-1j*2*pi*DELf/fs); 
G=czt(s.*wind,M,W,A);        % CZT变换 
GX=abs(G)*4/N;               % 求出CZT后的频谱幅值
[V,K]=findpeaks(GX,'minpeakheight',1);   % 寻找CZT频谱幅值的峰值并显示
ml=length(K);
for k=1 : ml
    fprintf('%5.2f   %5.2f\n',n2(K(k)),V(k));
end
% ZFFT
D=20; a=0.3;                 % 设置ZFFT的细化倍数和外扩系数
M=round(4*D/a);              % 计算滤波器半长M
L=20480+2*M;                 % 求出数据长度
n=1:L;                       % 样点索引
t=(n-1)/fs;                  % 时间序列
% 构成信号序列
s=3*cos(2*pi*f1*t)+4*cos(2*pi*f2*t+0.2)+5*cos(2*pi*f3*t+0.4);
fe=432;                      % 中心频率
[y,freq]=zoomffta(s,fs,N,fe,D,a); % ZFFT
[V,K]=findpeaks(abs(y),'minpeakheight',1);   % 寻找ZFFT频谱幅值的峰值并显示
ml=length(K);
for k=1 : ml
    fprintf('%5.2f   %5.2f\n',freq(K(k)),V(k));
end
% 作图
subplot 211; plot((n1-1)*df1,S(n1),'k');
title('FFT得到的全景幅值谱图')
xlabel('频率/Hz'); ylabel('幅值');
grid on; xlim([0 fs/2])
subplot 212; plot(n2,abs(GX),'k:',freq,abs(y),'k'); 
title('CZT和ZFFT得到的幅值谱图')
xlabel('频率/Hz'); ylabel('幅值');
grid on; xlim([428 438]); hold on
set(gcf,'color','w');




