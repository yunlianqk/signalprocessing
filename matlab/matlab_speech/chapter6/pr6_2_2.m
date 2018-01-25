%
% pr6_2_2 
clear all; clc; close all;

filedir=[];                             % 指定文件路径
filename='bluesky1.wav';                % 指定文件名
fle=[filedir filename]                  % 构成路径和文件名的字符串
[xx,fs]=wavread(fle);                   % 读入数据文件
xx=xx/max(abs(xx));                     % 幅度归一化
N=length(xx);                           % 取信号长度
time=(0:N-1)/fs;                        % 计算时间刻度
SNR=10;                                 % 信噪比
x=Gnoisegen(xx,SNR);                    % 把白噪声叠加到信号上

wlen=200; inc=80;                       % 设置帧长和帧移
IS=0.25; overlap=wlen-inc;              % 设置前导无话段长度
NIS=fix((IS*fs-wlen)/inc +1);           % 计算前导无话段帧数
y=enframe(x,wlen,inc)';                 % 分帧
fn=size(y,2);                           % 帧数
amp=sum(y.^2);                          % 求取短时平均能量
zcr=zc2(y,fn);                          % 计算短时平均过零率  
ampm = multimidfilter(amp,5);           % 中值滤波平滑处理
zcrm = multimidfilter(zcr,5);         
ampth=mean(ampm(1:NIS));                % 计算初始无话段区间能量和过零率的平均值 
zcrth=mean(zcrm(1:NIS));
amp2=1.1*ampth; amp1=1.3*ampth;         % 设置能量和过零率的阈值
zcr2=0.9*zcrth;

frameTime=frame2time(fn, wlen, inc, fs);% 计算各帧对应的时间
[voiceseg,vsl,SF,NF]=vad_param2D_revr(ampm,zcrm,amp2,amp1,zcr2);% 端点检测
% 作图
subplot 211; plot(time,xx,'k');
title('纯语音男声“蓝天，白云，碧绿的大海”波形');
ylabel('幅值'); axis([0 max(time) -1 1]); 
for k=1 : vsl
    nx1=voiceseg(k).begin; nx2=voiceseg(k).end;
    fprintf('%4d   %4d   %4d\n',k,nx1,nx2);
    line([frameTime(nx1) frameTime(nx1)],[-1.5 1.5],'color','k','LineStyle','-');
    line([frameTime(nx2) frameTime(nx2)],[-1.5 1.5],'color','k','LineStyle','--');
end
subplot 212; plot(time,x,'k');
title(['加噪语音波形(信噪比' num2str(SNR) 'dB)']);
ylabel('幅值'); axis([0 max(time) -1 1]);
xlabel('时间/s');

