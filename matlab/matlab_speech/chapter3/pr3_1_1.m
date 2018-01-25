%
% pr3_1_1
clear all; clc; close all;
y=load('su1.txt');                            % 读入数据
fs=16000; nfft=1024;                          % 采样频率和FFT的长度
time=(0:nfft-1)/fs;                           % 时间刻度
figure(1), subplot 211; plot(time,y,'k');     % 画出信号波形
title('信号波形'); axis([0 max(time) -0.7 0.7]);
ylabel('幅值'); xlabel(['时间/s' 10 '(a)']); grid;
figure(2)
nn=1:nfft/2; ff=(nn-1)*fs/nfft;               % 计算频率刻度
Y=log(abs(fft(y)));                           % 按式(3-1-8)取实数部分
subplot 211; plot(ff,Y(nn),'k'); hold on;     % 画出信号的频谱图
z=ifft(Y);                                    % 按式(3-1-8)求取倒谱
figure(1), subplot 212; plot(time,z,'k');     % 画出倒谱图
title('信号倒谱图'); axis([0 time(512) -0.2 0.2]); grid; 
ylabel('幅值'); xlabel(['倒频率/s' 10 '(b)']);
mcep=29;                                      % 分离声门激励脉冲和声道冲激响应
zy=z(1:mcep+1);
zy=[zy' zeros(1,nfft-2*mcep-1) zy(end:-1:2)']; % 构建声道冲激响应的倒谱序列
ZY=fft(zy);                                   % 计算声道冲激响应的频谱
figure(2),                                    % 画出声道冲激响应的频谱，用灰线表示
line(ff,real(ZY(nn)),'color',[.6 .6 .6],'linewidth',3);
grid; hold off; ylim([-4 5]);
title('信号频谱（黑线）和声道冲激响频谱（灰线）')
ylabel('幅值'); xlabel(['频率/Hz' 10 '(a)']); 

ft=[zeros(1,mcep+1) z(mcep+2:end-mcep)' zeros(1,mcep)]; % 构建声门激励脉冲的倒谱序列
FT=fft(ft);                                  % 计算声门激励脉冲的频谱
subplot 212; plot(ff,real(FT(nn)),'k'); grid;% 画出声门激励脉冲的频谱
title('声门激励脉冲频谱')
ylabel('幅值'); xlabel(['频率/Hz' 10 '(b)']); 

