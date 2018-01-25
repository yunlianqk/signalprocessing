%
% pr5_4_1
clear all; clc; close all;

A=input('请输入金额,小数点用*号表示,以#号结束:','s');
% 程序第一部分
fs=8000;                     % 采样频率
dth=0.05;                    % DTMF波形的时间长度
Doption=1;                   % 将显示波形
x=gendtmfcs(A,dth,Doption);  % 调用gendtmfcs函数产生DTMF序列
B=goertzel_decode(x,0.1);    % 应用Goertzel算法解码
fprintf('%s\n',B);           % 显示解码出的字符串

pause(1);
% 程序第二部分
SNR=10;                      % 设置信噪比
y=TouchToneDialler(A,SNR);   % 调用TouchToneDialler函数产生带噪DTMF序列
B=goertzel_decode(y,1);      % 应用Goertzel算法解码
fprintf('%s\n',B);           % 显示解码出的字符串
N=length(y);
time=(0:N-1)/fs;             % 时间刻度
% 作图
figure(1)
plot(time,y,'k'); grid;
line([0 max(time)],[1 1],'color','r');
xlim([0 max(time)]);
xlabel('时间/s'); ylabel('幅值')
set(gcf,'color','w');
wavplay(y,fs);

