%
% pr6_6_1 
clear all; clc; close all

run Set_I                               % 基本设置
run PART_I                              % 读入数据，分帧等准备

for i=1:fn
    Sp = abs(fft(y(:,i)));              % FFT变换取幅值
    Sp = Sp(1:wlen/2+1);	            % 只取正频率部分
    Ep=Sp.*Sp;                          % 求出能量
    prob = Ep/(sum(Ep));		        % 计算每条谱线的概率密度
    H(i) = -sum(prob.*log(prob+eps));  % 计算谱熵
end

Enm=multimidfilter(H,10);               % 平滑处理
Me=min(Enm);                            % 计算阈值 
eth=mean(Enm(1:NIS));                   
Det=eth-Me;
T1=0.98*Det+Me;
T2=0.93*Det+Me;
[voiceseg,vsl,SF,NF]=vad_param1D_revr(Enm,T1,T2);% 用双门限法反向检测端点
% 作图
subplot 311; 
plot(time,x,'k'); hold on
title('语音波形');
ylabel('幅值'); axis([0 max(time) -1 1]);
subplot 312; 
plot(time,signal,'k'); hold on
title(['带噪语音波形 SNR=' num2str(SNR) 'dB'] );
ylabel('幅值'); axis([0 max(time) -1 1]);
top=Det*1.1+Me;
botton=Me-0.1*Det;
subplot 313; plot(frameTime,Enm,'k');  axis([0 max(time) botton top]); 
line([0 fn],[T1 T1],'color','k','LineStyle','--');
line([0 fn],[T2 T2],'color','k','LineStyle','-');
title('短时谱熵'); xlabel('时间/s'); ylabel('谱熵值');
for k=1 : vsl                           % 标出语音端点
    nx1=voiceseg(k).begin; nx2=voiceseg(k).end;
    fprintf('%4d   %4d   %4d\n',k,nx1,nx2);
    subplot 311
    line([frameTime(nx1) frameTime(nx1)],[-1 1],'color','k','LineStyle','-');
    line([frameTime(nx2) frameTime(nx2)],[-1 1],'color','k','LineStyle','--');
    subplot 313
    line([frameTime(nx1) frameTime(nx1)],[botton top],'color','k','LineStyle','-');
    line([frameTime(nx2) frameTime(nx2)],[botton top],'color','k','LineStyle','--');
end

