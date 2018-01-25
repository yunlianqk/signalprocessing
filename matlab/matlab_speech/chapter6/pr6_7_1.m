% 
% pr6_7_1 
clear all; clc; close all;

run Set_I                               % 基本设置
run PART_I                              % 读入数据，分帧等准备

aparam=2; bparam=1;                     % 设置参数
etemp=sum(y.^2);                        % 计算能量
etemp1=log10(1+etemp/aparam);           % 计算能量的对数值
zcr=zc2(y,fn);                          % 求过零点值
Ecr=etemp1./(zcr+bparam);               % 计算能零比

Ecrm=multimidfilter(Ecr,2);             % 平滑处理
dth=mean(Ecrm(1:(NIS)));                % 阈值计算
T1=1.2*dth;
T2=2*dth;
[voiceseg,vsl,SF,NF]=vad_param1D(Ecrm,T1,T2);% 能零比法的双门限端点检测
% 作图
subplot 311; plot(time,x,'k');
title('纯语音波形');
ylabel('幅值'); axis([0 max(time) -1 1]);
subplot 312; plot(time,signal,'k');
title('加噪语音波形(信噪比10dB)');
ylabel('幅值'); axis([0 max(time) -1 1]);
subplot 313; plot(frameTime,Ecrm,'k');
title('短时能零比值'); grid; ylim([0 1.2*max(Ecrm)]);
xlabel('时间/s'); ylabel('能零比值'); 
line([0,frameTime(fn)], [T1 T1], 'color','k','LineStyle','--');
line([0,frameTime(fn)], [T2 T2], 'color','k','LineStyle','-');
for k=1 : vsl                           % 标出语音端点
    nx1=voiceseg(k).begin; nx2=voiceseg(k).end;
    fprintf('%4d   %4d   %4d\n',k,nx1,nx2);
    subplot 311; 
    line([frameTime(nx1) frameTime(nx1)],[-1 1],'color','k','LineStyle','-');
    line([frameTime(nx2) frameTime(nx2)],[-1 1],'color','k','LineStyle','--');
    subplot 313; 
    line([frameTime(nx1) frameTime(nx1)],[0 1.2*max(Ecrm)],'color','k','LineStyle','-');
    line([frameTime(nx2) frameTime(nx2)],[0 1.2*max(Ecrm)],'color','k','LineStyle','--');
end

