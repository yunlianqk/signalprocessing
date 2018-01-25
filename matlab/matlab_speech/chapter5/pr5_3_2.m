%
% pr5_3_2
clear all; clc; close all;

filedir=[];                         % 指定文件路径
filename='bluesky3.wav';            % 指定文件名
fle=[filedir filename];             
[s,fs]=audioread(fle);                % 读入数据文件
s=s-mean(s);                        % 消除直流分量
s=s/max(abs(s));                    % 幅值归一化
N=length(s);                        % 求出数据长度
time=(0:N-1)/fs;                    % 求出时间刻度
subplot 411; plot(time,s,'k');      % 画出纯语音信号的波形图
title('纯语音信号'); ylabel('幅值')

SNR=[5 0 -5];                       % 信噪比的取值区间
for k=1 : 3 
    snr=SNR(k);                     % 设定信噪比
    data=sin(2*pi*16000*time);        % 产生一个正弦信号
    [x,noise]=add_noisedata(s,data,fs,fs,snr); % 按信噪比构成正弦信号叠加到语音上
    subplot(4,1,k+1); plot(time,x,'k'); ylabel('幅值');  % 作图
    ylim([-2 2]);
    snr1=SNR_singlech(s,x);         % 计算出带噪语音中的信噪比
    fprintf('k=%4d  snr=%5.1f  snr1=%5.4f\n',k,snr,snr1);
    title(['带噪语音信号 设定信噪比=' num2str(snr) 'dB  计算出信噪比=' ...
        num2str(round(snr1*1e4)/1e4) 'dB']);
end
xlabel('时间/s')
    
    
    