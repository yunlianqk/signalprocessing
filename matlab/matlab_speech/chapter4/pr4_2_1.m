%
% pr4_2_1 
clear all; clc; close all;

filedir=[];                             % 设置数据文件的路径
filename='aa.wav';                      % 设置数据文件的名称
fle=[filedir filename]                  % 构成路径和文件名的字符串
[x,fs]=wavread(fle);                    % 读入语音数据
L=240;                                  % 帧长
y=x(8001:8000+L);                       % 取一帧数据
p=12;                                   % LPC的阶数
ar=lpc(y,p);                            % 线性预测变换
Y=lpcar2ff(ar,255);                     % 求LPC的频谱值
est_x=filter([0 -ar(2:end)],1,y);       % 用LPC求预测估算值
err=y-est_x;                            % 求出预测误差
fprintf('LPC:\n');
fprintf('%5.4f   %5.4f   %5.4f   %5.4f   %5.4f   %5.4f   %5.4f\n',ar);
fprintf('\n');
% 作图
pos = get(gcf,'Position');
set(gcf,'Position',[pos(1), pos(2)-200,pos(3),pos(4)+150]);
subplot 311; plot(x,'k'); axis tight;
title('元音/a/波形'); ylabel('幅值')
subplot 323; plot(y,'k'); xlim([0 L]); 
title('一帧数据'); ylabel('幅值')
subplot 324; plot(est_x,'k'); xlim([0 L]); 
title('预测值'); ylabel('幅值')
subplot 325; plot(abs(Y),'k'); xlim([0 L]); 
title('LPC频谱'); ylabel('幅值'); xlabel('样点')
subplot 326; plot(err,'k'); xlim([0 L]); 
title('预测误差'); ylabel('幅值'); xlabel('样点')









