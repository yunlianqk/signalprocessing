%
% pr3_16_3 
clc; clear all; close all;

[x,Fs]=wavread('m_noise.wav');% 读入数据和采样频率
Pref=2e-5;                    % 参考声压
% 1/3倍频程滤波器中心频率
ff = [ 20, 25 31.5 40, 50 63 80, 100 125 160,...                       
    200 250 315, 400 500 630, 800 1000 1250, 1600 2000 2500, ...   
	3150 4000 5000, 6300 8000 10000, 12500 16000]; 
nc=length(ff);                % 1/3滤波器个数
P = zeros(1,nc);              % 初始化
m = length(x);                % x的长度
oc6=2^(1/6);                  % 倍频程的比例

for i=1:nc
    fl=ff(i)/oc6;             % 求出1/3倍频程低截止频率
    fu=ff(i)*oc6;             % 求出1/3倍频程高截止频率
% 调用fdesign+designign函数计算滤波器系数集合Hd    
    d=fdesign.bandpass('N,F3DB1,F3DB2',8,fl,fu,Fs);
    Hd=design(d);
    y = filter(Hd,x);         % 滤波
    P(i) = sum(y.^2)/m;       % 计算输出信号的均方值 
end
% 计算各频带的声压级和总声压级
Psum=0;
for i=1 : nc
    Pow(i) = 10*log10(P(i)/Pref^2);% 计算各频带的声压级
    Psum=Psum+P(i);           % 能量相加
end
Lps=10*log10(Psum/Pref^2);    % 计算总声压级
fprintf('LPS=%5.6fdB\n',Lps);

bar(Pow);
set(gca,'XTick',[2:3:30]); grid		 
set(gca,'XTickLabels',ff(2:3:length(ff)));  
xlabel('中心频率/Hz'); ylabel('声压级/dB');
title('三分之一倍频程滤波器输出声压级')
set(gcf,'color','w'); 





