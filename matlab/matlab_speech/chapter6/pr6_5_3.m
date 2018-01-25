%
% pr6_5_3 
clear all; clc; close all;

run Set_I                               % 基本设置
run PART_I                              % 读入数据，分帧等准备
ccc=mfcc_m(signal,fs,16,wlen,inc);      % 计算MFCC
fn1=size(ccc,1);                        % 取帧数1
frameTime1=frameTime(3:fn-2);           % MFCC对应的时间刻度
Ccep=ccc(:,1:16);                       % 取得MFCC系数
C0=mean(Ccep(1:5,:),1);                 % 计算噪声平均MFCC倒谱系数的估计值
for i=6 : fn1
    Cn=Ccep(i,:);                       % 取一帧MFCC倒谱系数
    Dstu=0;
    for k=1 : 16                        % 从第6帧开始计算每帧MFCC倒谱系数与
        Dstu=Dstu+(Cn(k)-C0(k))^2;      % 噪声MFCC倒谱系数的距离
    end
    Dcep(i)=sqrt(Dstu);
end
Dcep(1:5)=Dcep(6);

Dstm=multimidfilter(Dcep,2);            % 平滑处理
dth=max(Dstm(1:NIS-2));                 % 阈值计算
T1=1.2*dth;
T2=1.5*dth;
[voiceseg,vsl,SF,NF]=vad_param1D(Dstm,T1,T2);% MFCC倒谱距离双门限的端点检测
% 作图
subplot 311; plot(time,x,'k');
title('纯语音波形');
ylabel('幅值'); axis([0 max(time) -1 1]);
subplot 312; plot(time,signal,'k');
title('加噪语音波形(信噪比10dB)');
ylabel('幅值'); axis([0 max(time) -1 1]);
subplot 313; plot(frameTime1,Dstm,'k');
title('短时MFCC倒谱距离值'); axis([0 max(time) 0 1.2*max(Dstm)]);
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
    line([frameTime(nx1) frameTime(nx1)],[0 1.2*max(Dstm)],'color','k','LineStyle','-');
    line([frameTime(nx2) frameTime(nx2)],[0 1.2*max(Dstm)],'color','k','LineStyle','--');
end


    