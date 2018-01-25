%
% pr3_16_2 
clc; clear all; close all;

[x,Fs]=wavread('m_noise.wav');% 读入数据和采样频率
Pref=2e-5;                    % 参考声压
N = 3; 					      % 滤波器阶数 
% 1/3倍频程滤波器中心频率
ff = [ 20, 25 31.5 40, 50 63 80, 100 125 160,...                              
    200 250 315, 400 500 630, 800 1000 1250, 1600 2000 2500, ...   
	3150 4000 5000, 6300 8000 10000, 12500 16000]; 
nc=length(ff);                % 1/3滤波器个数
P = zeros(1,nc);              % 初始化
m = length(x);                % x的长度
oc6=2^(1/6);                  % 倍频程的比例

for i=nc : -1 :20             % 在第20~30个1/3倍频程滤波器不需要降采样
   [B,A] = oct3filt(ff(i),Fs,N);% 计算带通滤波器的系数
   y = filter(B,A,x);         % 滤波
   P(i) = sum(y.^2)/m;        % 计算输出信号的均方值
end
% 1250Hz至20Hz的1/3倍频程滤波器都需要降采样,按每一个倍频程来计算采样频率  
[Bu,Au]=oct3filt(ff(22),Fs,N);% 2500Hz时1/3倍频程滤波器系数 
[Bc,Ac]=oct3filt(ff(21),Fs,N);% 2000Hz时1/3倍频程滤波器系数 
[Bl,Al]=oct3filt(ff(20),Fs,N);% 1600Hz时1/3倍频程滤波器系数 

for j = 5:-1:0                % 设计1250Hz至25Hz的1/3倍频程滤波器和滤波
   x = decimate(x,2);         % 采样频率减半
   m = length(x);             % 数据长度
   y = filter(Bu,Au,x);       % 对一倍频中第1滤波器进行滤波
   P(j*3+4) = sum(y.^2)/m;    % 计算滤波输出的均方值
   y = filter(Bc,Ac,x);       % 对一倍频中第2滤波器进行滤波 
   P(j*3+3) = sum(y.^2)/m;    % 计算滤波输出的均方值    
   y = filter(Bl,Al,x);       % 对一倍频中第3滤波器进行滤波 
   P(j*3+2) = sum(y.^2)/m;    % 计算滤波输出的均方值 
end
x = decimate(x,2);            % 采样频率减半 
m = length(x);                % 数据长度
y = filter(Bu,Au,x);          % 对20Hz滤波器进行滤波
P(1) = sum(y.^2)/m;           % 计算滤波输出的均方值 
% 计算各频带的声压级和总声压级
Psum=0;
for i=1 : nc
    Pow(i) = 10*log10(P(i)/Pref^2);% 计算各频带的声压级
    Psum=Psum+P(i);           % 能量相加
end
Lps=10*log10(Psum/Pref^2);    % 计算总声压级
fprintf('LPS=%5.6fdB\n',Lps);

% 作图
bar(Pow);
set(gca,'XTick',[2:3:30]); grid		 
set(gca,'XTickLabels',ff(2:3:length(ff)));  
xlabel('中心频率/Hz'); ylabel('声压级/dB');
title('三分之一倍频程滤波器输出声压级')
set(gcf,'color','w'); 





