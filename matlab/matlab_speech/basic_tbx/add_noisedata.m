function [signal,noise]=add_noisedata(s,data,fs,fs1,snr)
s=s(:);                          % 把信号转换成列数据
s=s-mean(s);                     % 消除直流分量
sL=length(s);                    % 求出信号的长度

if fs~=fs1                       % 若纯语音信号的采样频率与噪声的采样频率不相等
    x=resample(data,fs,fs1);     % 对噪声重采样，使噪声采样频率与纯语音信号的采样频率相同
else
    x=data;
end

x=x(:);                          % 把噪声数据转换成列数据
x=x-mean(x);                     % 消除直流分量
xL=length(x);                    % 求噪声数据长度
if xL>=sL                        % 如果噪声数据长度与信号数据长度不等，把噪声数据截断或补足
    x=x(1:sL);
else
    disp('Warning: 噪声数据短于信号数据，以补0来补足！')
    x=[x; zeros(sL-xL,1)];
end

Sr=snr;
Es=sum(x.*x);                    % 求出信号的能量
Ev=sum(s.*s);                    % 求出噪声的能量
a=sqrt(Ev/Es/(10^(Sr/10)));      % 计算出噪声的比例因子
noise=a*x;                       % 调整噪声的幅值
signal=s+noise;                  % 构成带噪语音

