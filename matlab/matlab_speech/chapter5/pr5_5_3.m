%
% pr5_5_3 
clear all; clc; close all;

As=50;Fs=8000; Fs2=Fs/2;                % 最小衰减和采样频率
fs1=49; fs2=51;                         % 阻带频率
fp1=45; fp2=55;                         % 通带频率
df=min(fs1-fp1,fp2-fs2);                % 求过渡带宽
M0=round((As-7.95)/(14.36*df/Fs))+2;    % 按式(5-5-4)求凯泽窗长
M=M0+mod(M0+1,2);                       % 保证窗长为奇数
wp1=fp1/Fs2*pi; wp2=fp2/Fs2*pi;         % 转换成归一化圆频率
ws1=fs1/Fs2*pi; ws2=fs2/Fs2*pi;
wc1=(wp1+ws1)/2; wc2=(wp2+ws2)/2;       % 求截止频率
beta=0.5842*(As-21)^0.4+0.07886*(As-21);% 按式(5-5-5)求出beta值
fprintf('beta=%5.6f\n',beta);
M=M-1;                                  % 阶次和窗长差1
b=fir1(M,[wc1 wc2]/pi,'stop',kaiser(M+1,beta));  % 计算FIR滤波器系数
[h,w]=freqz(b,1,4000);                  % 求幅值的频率响应
db=20*log10(abs(h));

filedir=[];                             % 指定文件路径
filename='bluesky3.wav';                % 指定文件名
fle=[filedir filename]                  % 构成路径和文件名的字符串
[s,fs]=wavread(fle);                    % 读入数据文件
s=s-mean(s);                            % 消除直流分量
s=s/max(abs(s));                        % 幅值归一化
N=length(s);                            % 求出信号长度
t=(0:N-1)/fs;                           % 设置时间
ns=0.5*cos(2*pi*50*t);                  % 计算出50Hz工频信号
x=s+ns';                                % 语音信号和50Hz工频信号叠加
snr1=SNR_singlech(s,x)                  % 计算叠加50Hz工频信号后的信噪比
y=conv(b,x);                            % FIR带陷滤波，输出为y
z=y(fix(M/2)+1:end-fix(M/2));           % 消除conv带来的滤波器输出延迟的影响
snr2=SNR_singlech(s,z)                  % 计算滤波后语音信号的信噪比
% 作图
figure(1)                                  
plot(w/pi*Fs2,db,'k','linewidth',2);
title('幅频响应曲线');
xlabel('频率/Hz');ylabel('幅值/dB');grid on;  axis([0 100 -60 5])
figure(2)
subplot 311; plot(t,s,'k'); 
title('纯语音信号：男声“蓝天，白云”')
xlabel('时间/s'); ylabel('幅值')
axis([0 max(t) -1.2 1.2]);
subplot 312; plot(t,x,'k'); 
title('带50Hz工频信号的语音信号')
xlabel('时间/s'); ylabel('幅值')
axis([0 max(t) -1.2 1.2]);
subplot 313; plot(t,z,'k'); 
title('消除50Hz工频信号后的语音信号')
xlabel('时间/s'); ylabel('幅值')
axis([0 max(t) -1.2 1.2]);

