%
% pr6_3_1 
clear all; clc; close all;

run Set_I                               % 基本设置
run PART_I                              % 读入数据，分帧等准备

for k=2 : fn                            % 计算自相关函数
    u=y(:,k);
    ru=xcorr(u);
    Ru(k)=max(ru);
end
Rum=multimidfilter(Ru,10);              % 平滑处理
Rum=Rum/max(Rum);                       % 归一化
thredth=max(Rum(1:NIS));                % 计算阈值
T1=1.1*thredth;
T2=1.3*thredth;
[voiceseg,vsl,SF,NF]=vad_param1D(Rum,T1,T2);% 自相关函数的端点检测
% 作图
subplot 311; plot(time,x,'k');
title('纯语音波形');
ylabel('幅值'); axis([0 max(time) -1 1]);
subplot 312; plot(time,signal,'k');
title(['加噪语音波形(信噪比' num2str(SNR) 'dB)']);
ylabel('幅值'); axis([0 max(time) -1 1]);
subplot 313; plot(frameTime,Rum,'k');
title('短时自相关函数'); axis([0 max(time) 0 1.2]);
xlabel('时间/s'); ylabel('幅值'); 
line([0,frameTime(fn)], [T1 T1], 'color','k','LineStyle','--');
line([0,frameTime(fn)], [T2 T2], 'color','k','LineStyle','-');
for k=1 : vsl                           % 标出语音端点
    nx1=voiceseg(k).begin; nx2=voiceseg(k).end;
    fprintf('%4d   %4d   %4d\n',k,nx1,nx2);
    subplot 311; 
    line([frameTime(nx1) frameTime(nx1)],[-1 1],'color','k','LineStyle','-');
    line([frameTime(nx2) frameTime(nx2)],[-1 1],'color','k','LineStyle','--');
end



