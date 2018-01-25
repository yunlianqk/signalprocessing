%
% pr4_3_1 
clear all; clc; close all;

filedir=[];                             % 设置数据文件的路径
filename='aa.wav';                      % 设置数据文件的名称
fle=[filedir filename];                 % 构成路径和文件名的字符串
[x,fs]=wavread(fle);                    % 读入语音数据
L=240;                                  % 帧长
p=12;                                   % LPC的阶数
y=x(8001:8240+p);                       % 取一帧数据

[EL,alphal,GL,k]=latticem(y,L,p);       % 格型预测法
ar=alphal(:,p);
a1=lpc(y,p);                            % 普通预测法
Y=lpcar2pf(a1,255);                     % 把a1转成功率谱
Y1=lpcar2pf([1; -ar],255);              % 把ar转成功率谱
fprintf('AR1系数(格型预测法):\n');
fprintf('%5.4f   %5.4f   %5.4f   %5.4f   %5.4f   %5.4f\n',-ar);
fprintf('AR2系数(普通预测法):\n');
fprintf('%5.4f   %5.4f   %5.4f   %5.4f   %5.4f   %5.4f\n',a1(2:p+1));
% 作图
m=1:257;
freq=(m-1)*fs/512;
plot(freq,10*log10(Y),'k'); grid;
line(freq,10*log10(Y1),'color',[.6 .6 .6],'linewidth',2);
legend('普通预测法','格型预测法'); ylabel('幅值/dB');
title('普通预测法和格型预测法功率谱响应的比较'); xlabel('频率/Hz');
 


