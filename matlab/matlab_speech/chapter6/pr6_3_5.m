%
% pr6_3_5  
clear all; clc; close all;

run Set_I                               % 基本设置
run PART_I                              % 读入数据，分帧等准备

Rw=zeros(2*wlen-1,1);                   % Rw初始化
for k=1 : NIS                           % 按式(6-3-6)计算Rw
    u=y(:,k);                           % 取一帧数据
    ru=xcorr(u);                        % 计算自相关函数
    Rw=Rw+ru;
end
Rw=Rw/NIS;
Rw2=sum(Rw.*Rw);                        % 计算式(6-3-5)中分母内Rw的部分

for k=1 : fn
    u=y(:,k);                           % 取一帧数据
    ru=xcorr(u);                        % 计算自相关函数
    Cm=sum(ru.*Rw);                     % 计算式(6-3-5)中分子部分
    Cru=sum(ru.*ru);                    % 计算式(6-3-5)中分母内Ry的部分
    Ru(k)=Cm/sqrt(Rw2*Cru);             % 计算式(6-3-5)每帧的自相关函数余弦夹角
end

Rum=multimidfilter(Ru,10);              % 平滑处理
alphath=mean(Rum(1:NIS));               % 设置阈值
T2=0.8*alphath; T1=0.9*alphath;
[voiceseg,vsl,SF,NF]=vad_param1D_revr(Rum,T1,T2);   % 单参数双门限反向端点检测
% 作图
subplot 311; plot(time,x,'k');
title('纯语音波形');
ylabel('幅值'); axis([0 max(time) -1 1]);
subplot 312; plot(time,signal,'k');
title(['加噪语音波形(信噪比' num2str(SNR) 'dB)']);
ylabel('幅值'); axis([0 max(time) -1 1]);
subplot 313; plot(frameTime,Rum,'k');
title('短时自相关函数余弦夹角值'); axis([0 max(time) 0 1]);
xlabel('时间/s'); ylabel('幅值'); 
line([0,frameTime(fn)], [T1 T1], 'color','k','LineStyle','--');
line([0,frameTime(fn)], [T2 T2], 'color','k','LineStyle','-');
for k=1 : vsl                           % 标出语音端点
    nx1=voiceseg(k).begin; nx2=voiceseg(k).end;
    fprintf('%4d   %4d   %4d\n',k,nx1,nx2);
    subplot 311; 
    line([frameTime(nx1) frameTime(nx1)],[-1 1],'color','k','LineStyle','-');
    line([frameTime(nx2) frameTime(nx2)],[-1 1],'color','k','LineStyle','--');
    subplot 313; 
    line([frameTime(nx1) frameTime(nx1)],[0 1.2],'color','k','LineStyle','-');
    line([frameTime(nx2) frameTime(nx2)],[0 1.2],'color','k','LineStyle','--');
end


