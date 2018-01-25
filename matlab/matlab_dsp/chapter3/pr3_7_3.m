%
% pr3_7_3 
clear all; close all; clc;

[y,Fs]=wavread('San2.wav');        % 读入数据
fc=3400;fb=3700;                   % 设置通带和阻带截止频率
Rp=3;Rs=60;                        % 设置通带波纹和阻带衰减
wp=2*pi*fc/Fs;ws=2*pi*fb/Fs;       % 计算归一化频率
Ts=1/Fs;
Wp=2/Ts*tan(wp/2.);Ws=2/Ts*tan(ws/2.);% 模拟频率进行预畸
[M,Wn]=ellipord(Wp,Ws,Rp,Rs,'s');   % 得到模拟滤波器原型阶数和带宽
[bs,as]=ellip(M,Rp,Rs,Wn,'s');      % 得到模拟滤波器系数
[b,a]=bilinear(bs,as,Fs);           % 双线性Z变换得数字滤波器系数

x=filter(b,a,y);                    % 对数据进行滤波
Y=fft(y);                           % 求输入和输出信号的谱图
X=fft(x);
N=length(x);
n2=1:N/2;
freq=(n2-1)*Fs/N;
% 作图
[H,ff]=freqz(b,a,1000,Fs);          % 观察数字滤波器的响应曲线
plot(ff,20*log10(abs(H)),'k');
xlabel('频率/Hz'); ylabel('幅值/dB')
title('椭圆滤波器幅频响应曲线'); 
ylim([-80 10]); grid;
set(gcf,'color','w');
figure
subplot 211; plot(freq,abs(Y(n2)),'k'); % 输入信号谱图
xlabel('频率/Hz'); title('输入信号谱图')
subplot 212; plot(freq,abs(X(n2)),'k'); % 输出信号谱图
xlabel('频率/Hz'); title('输出信号谱图')
set(gcf,'color','w');

