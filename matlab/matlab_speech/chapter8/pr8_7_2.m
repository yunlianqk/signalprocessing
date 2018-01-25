%
% pr8_7_2  
clear all; clc; close all;

filedir=[];                             % 设置数据文件的路径
filename='tone4.wav';                   % 设置数据文件的名称
fle=[filedir filename]                  % 构成路径和文件名的字符串
[x,fs]=wavread(fle);                    % 读取文件
x=x-mean(x);                            % 消除直流分量
x=x/max(abs(x));                        % 幅值归一化
SNR=0;                                  % 设置信噪比
signal=Gnoisegen(x,SNR);                % 叠加噪声
snr1=SNR_singlech(x,signal)             % 计算初始信噪比值
N=length(x);                            % 信号长度
time = (0 : N-1)/fs;                    % 设置时间刻度
wlen=320; inc=80;                       % 帧长和帧移
overlap=wlen-inc;                       % 两帧重叠长度  
IS=0.15;                                % 设置前导无话段长度
NIS=fix((IS*fs-wlen)/inc +1);           % 求前导无话段帧数

a=3; b=0.001;                           % 设置参数a和b
output=simplesubspec(signal,wlen,inc,NIS,a,b); % 谱减运算
snr2=SNR_singlech(x,output)             % 计算谱减后信噪比值
y  = enframe(output,wlen,inc)';         % 分帧
fn  = size(y,2);                        % 取得帧数
time = (0 : length(x)-1)/fs;            % 计算时间坐标
frameTime = frame2time(fn, wlen, inc, fs);% 计算每一帧对应的时间
T1=0.12;                                 % 设置基音端点检测的参数

[voiceseg,vosl,SF,Ef]=pitch_vad1(y,fn,T1);   % 基音的端点检测
% 60～500Hz的带通滤波器系数
b=[0.012280   -0.039508   0.042177   0.000000   -0.042177   0.039508   -0.012280];
a=[1.000000   -5.527146   12.854342   -16.110307   11.479789   -4.410179   0.713507];
z=filter(b,a,output);                   % 带通数字滤波
yy  = enframe(z,wlen,inc)';             % 滤波后信号分帧

lmin=floor(fs/500);                     % 基音周期的最小值
lmax=floor(fs/60);                      % 基音周期的最大值
period=zeros(1,fn);                     % 基音周期初始化
period=ACF_corr(yy,fn,voiceseg,vosl,lmax,lmin);  % 用自相关函数提取基音周期
tindex=find(period~=0);
F0=zeros(1,fn);                         % 初始化 
F0(tindex)=fs./period(tindex);          % 求出基音频率
TT=pitfilterm1(period,voiceseg,vosl);   % 对基音周期进行平滑滤波
FF=pitfilterm1(F0,voiceseg,vosl);       % 对基音频率进行平滑滤波
% 作图
pos = get(gcf,'Position');
set(gcf,'Position',[pos(1), pos(2)-150,pos(3),pos(4)+100]);
subplot 611; plot(time,x,'k'); ylabel('幅值');
title('原始信号'); axis([0 max(time) -1 1]);
for k=1 : vosl
        line([frameTime(voiceseg(k).begin) frameTime(voiceseg(k).begin)],...
        [-1 1],'color','k');
        line([frameTime(voiceseg(k).end) frameTime(voiceseg(k).end)],...
        [-1 1],'color','k','linestyle','--');
end
subplot 612; plot(time,signal,'k'); ylabel('幅值');
title('带噪信号'); axis([0 max(time) -1 1]);
subplot 613; plot(time,output,'k');
title('消噪信号'); axis([0 max(time) -1 1]); ylabel('幅值');
subplot 614; plot(frameTime,Ef,'k'); hold on; ylabel('幅值');
title('能熵比'); axis([0 max(time) 0 max(Ef)]);
line([0 max(frameTime)],[T1 T1],'color','k','linestyle','--');
for k=1 : vosl
        line([frameTime(voiceseg(k).begin) frameTime(voiceseg(k).begin)],...
        [-1 1],'color','k');
        line([frameTime(voiceseg(k).end) frameTime(voiceseg(k).end)],...
        [-1 1],'color','k','linestyle','--');
end
text(3.2,0.2,'T1');
subplot 615; plot(frameTime,TT,'k');  ylabel('样点数');
title('基音周期'); grid; axis([0 max(time) 0 80]);
subplot 616; plot(frameTime,FF,'k'); ylabel('频率/Hz')
title('基音频率'); grid; axis([0 max(time) 0 450]); xlabel('时间/s'); 
