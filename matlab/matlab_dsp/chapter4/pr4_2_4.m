%
% pr4_2_4 
clear all; clc; close all;

load Evnespecdata.mat                  % 读入语音频谱包络文件
[Val1,Loc1]=findpeaks(spect);          % 用findpeaks提取共振峰信息
df=freq(2)-freq(1);                    % 求出频率间隔
FRMNT1=(Loc1-1)*df;                    % 求出共振峰频率
% 显示共振峰信息
fprintf('%5.4f   %5.4f   %5.4f   %5.4f\n',Val1);
fprintf('%5.2f   %5.2f   %5.2f   %5.2f\n',FRMNT1);

[Loc2,Val2]=findpeakm(spect,'q');      % 用findpeakm提取共振峰信息
FRMNT2=(Loc2-1)*df;                    % 求出共振峰频率
% 显示共振峰信息
fprintf('%5.4f   %5.4f   %5.4f   %5.4f\n',Val2);
fprintf('%5.2f   %5.2f   %5.2f   %5.2f\n',FRMNT2);
% 作图
plot(freq,spect,'k','linewidth',2); 
hold on; grid; ylim([-6 1]);
for k=1 : 4
    plot(FRMNT1(k),Val1(k),'rO','linewidth',3.5);
    plot(FRMNT2(k),Val2(k),'kO','linewidth',3.5);
end
title('通过内插修正共振峰频率')
xlabel('频率/Hz'); ylabel('幅值/dB');
set(gcf,'color','w');



