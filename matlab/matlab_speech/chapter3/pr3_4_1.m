%
% pr3_4_1 
clear all; clc; close all;

[x,fs]=wavread('awav.wav');             % 读入语音数据
N=length(x);                            % 信号长度
x=x-mean(x);                            % 消除直流分量
J=2;                                    % 设小波变换级数为J
[C,L] = wavedec(x,J,'db1');             % 对时间序列进行一维多分辨分解
CaLen=N/2.^J;                           % 估计近似部分的系数长度
Ca=C(1:CaLen);                          % 取近似部分的系数
Ca=(Ca-min(Ca))./(max(Ca)-min(Ca));     % 对近似部分系数做规正处理
for i=1:CaLen                           % 对近似部分系数做削波
    if(Ca(i)<0.8), Ca(i)=0; end
end
[K,V]=findpeaks(Ca,[],6);               % 寻找峰值位置和数值
lk=length(K);
if lk~=0
    for i=2 : lk
        dis(i-1)=K(i)-K(i-1)+1;         % 寻找峰值之间的间隔
    end
    distance=mean(dis);                 % 取间隔的平均值
    pit=fs/2.^J/distance                % 计算这一帧的基音频率
else
    pit=0;
end
% 作图
subplot 211; plot(x,'k'); 
title('一帧语音信号')
subplot 212; plot(Ca,'k');
title('用小波分解得到的近似系数中心削波后的峰值图')

