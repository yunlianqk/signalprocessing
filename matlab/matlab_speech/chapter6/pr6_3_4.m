%
% pr6_3_4   
clear all; clc; close all;

run Set_I                               % 基本设置
run PART_I                              % 读入数据，分帧等准备

for k=1 : fn
    u=y(:,k);                           % 取一帧数据
    ru=xcorr(u);                        % 计算自相关函数
    ru0=ru(wlen);                       % 取主峰值
    ru1=max(ru(wlen+17:wlen+133));      % 取第一个副峰值
    R1(k)=ru0/ru1;                      % 计算主副峰比值
end
Rum=multimidfilter(R1,20);              % 平滑处理
Rum=Rum/max(Rum);                       % 数值归一化

alphath=mean(Rum(1:NIS));               % 设置阈值
T1=0.95*alphath; 
T2=0.75*alphath;
[voiceseg,vsl,SF,NF]=vad_param1D_revr(Rum,T1,T2);% 单参数双门限反向端点检测

% 作图
subplot 311; plot(time,x,'k');
title('纯语音波形');
ylabel('幅值'); axis([0 max(time) -1 1]);
subplot 312; plot(time,signal,'k');
title(['加噪语音波形(信噪比' num2str(SNR) 'dB)']);
ylabel('幅值'); axis([0 max(time) -1 1]);
subplot 313; plot(frameTime,Rum,'k');
title('短时自相关函数主副峰值比'); axis([0 max(time) 0 1.2]);
xlabel('时间/s'); ylabel('幅值'); 
line([0,frameTime(fn)], [T1 T1], 'color','k','LineStyle','--');
line([0,frameTime(fn)], [T2 T2], 'color','k','LineStyle','-');
% 标出语音端点
for k=1 : vsl
    nx1=voiceseg(k).begin; nx2=voiceseg(k).end;
    fprintf('%4d   %4d   %4d\n',k,nx1,nx2);
    subplot 311; 
    line([frameTime(nx1) frameTime(nx1)],[-1 1],'color','k','LineStyle','-');
    line([frameTime(nx2) frameTime(nx2)],[-1 1],'color','k','LineStyle','--');
    subplot 313; 
    line([frameTime(nx1) frameTime(nx1)],[0 1.2],'color','k','LineStyle','-');
    line([frameTime(nx2) frameTime(nx2)],[0 1.2],'color','k','LineStyle','--');
end

