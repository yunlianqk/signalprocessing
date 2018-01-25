%
% pr4_3_4 from p431mo 
clear all; clc; close all;
y=load('su1.txt');                            % 读入数据
fs=16000; nfft=1024;                          % 采样频率和FFT的长度
time=(0:nfft-1)/fs;                           % 时间刻度
nn=1:nfft/2; ff=(nn-1)*fs/nfft;               % 计算频率刻度
Y=log(abs(fft(y)));                           % 取幅值的对数
z=ifft(Y);                                    % 按式(4-3-16)求取倒谱
mcep=29;                                      % 分离声门激励脉冲和声道冲击响应
zy=z(1:mcep+1);
zy=[zy' zeros(1,1024-2*mcep-1) zy(end:-1:2)']; % 构建声道冲击响应的倒谱序列
ZY=fft(zy);                                   % 计算声道冲击响应的频谱
% 作图
plot(ff,Y(nn),'k'); hold on;                  % 画出信号的频谱图
plot(ff,real(ZY(nn)),'k','linewidth',2.5);    % 画出包络线
grid; hold off; ylim([-4 5]);
title('信号频谱和声道冲击响频谱（频谱包络）')
ylabel('幅值'); xlabel('频率/Hz'); 
legend('信号频谱','频谱包络')
set(gcf,'color','w');

