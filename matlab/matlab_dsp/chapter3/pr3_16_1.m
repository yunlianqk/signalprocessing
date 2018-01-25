%
% pr3_16_1  
clc; clear all; close all;

[x,fs]=wavread('m_noise.wav');% 读入数据和采样频率
p0=2e-5;                      % 参考声压
% 1/3倍频程滤波器中心频率
fc = [ 20, 25 31.5 40, 50 63 80, 100 125 160,...                  
    200 250 315, 400 500 630, 800 1000 1250, 1600 2000 2500, ...   
	3150 4000 5000, 6300 8000 10000, 12500 16000]; 
nc=length(fc);                % 1/3滤波器个数
n=length(x);                  % x的长度
t=(0:1/fs:(n-1)/fs);          % 时间刻度
nfft=2^nextpow2(n);           % FFT变换的长度,为2的整数幂次
a = fft(x,nfft);              % FFT变换
oc6=2^(1/6);                  % 倍频程的比例
% 1/3倍频程分析计算
for j=1:nc
    fl=fc(j)/oc6;             % 求出1/3倍频程下限截止频率
    fu=fc(j)*oc6;             % 求出1/3倍频程上限截止频率
    nl=round(fl*nfft/fs+1);   % 下限截止频率对应的频率索引
    nu=round(fu*nfft/fs+1);   % 上限截止频率对应的频率索引
    b=zeros(1,nfft);          % b初始化
    b(nl:nu)=a(nl:nu);        % 把1/3倍频程滤波器的谱线放于b中
    b(nfft-nu+2:nfft-nl+2)=a(nfft-nu+2:nfft-nl+2);
    c=real(ifft(b,nfft));     % IFFT逆变换
    yc(j)=sqrt(var((c(1:n))));% 求出均方根值
    Lp1(j)=20*log10(yc(j)/p0);% 计算1/3倍频程滤波器的声压级
end
Lpt=10*log10(sum((yc/p0).^2));% 计算总声压级
fprintf('Lpt=%5.6fdB\n',Lpt)
% 作图
figure(1)
pos = get(gcf,'Position');
set(gcf,'Position',[pos(1), pos(2)-100,pos(3),(pos(4)-140)]);
plot(t,x,'k');  % 瞬时声压波形图
xlabel('时间/s'); ylabel('幅值/帕');
title('噪声时间波形')
set(gcf,'color','w'); 
figure(2)
bar(Lp1(1:nc));
set(gca,'XTick',[2:3:30]); grid		 
set(gca,'XTickLabels',fc(2:3:length(fc)));  
xlabel('中心频率/Hz'); ylabel('声压级/dB');
title('三分之一倍频程滤波器输出声压级')
set(gcf,'color','w'); 
