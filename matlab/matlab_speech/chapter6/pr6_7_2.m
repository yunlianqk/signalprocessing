%
% pr6_7_2 
clear all; clc; close all

run Set_I                                    % 基本设置
run PART_I                                   % 读入数据，分帧等准备
aparam=2;                                    % 设置参数
for i=1:fn
    Sp = abs(fft(y(:,i)));                   % FFT变换取幅值
    Sp = Sp(1:wlen/2+1);	                 % 只取正频率部分
    Esum(i) = log10(1+sum(Sp.*Sp)/aparam);   % 计算对数能量值
    prob = Sp/(sum(Sp));		             % 计算概率
    H(i) = -sum(prob.*log(prob+eps));        % 求谱熵值
    Ef(i) = sqrt(1 + abs(Esum(i)/H(i)));     % 计算能熵比
end   

Enm=multimidfilter(Ef,10);                   % 平滑滤波 
Me=max(Enm);                                 % Enm最大值
eth=mean(Enm(1:NIS));                        % 初始均值eth
Det=Me-eth;                                  % 求出值后设置阈值
T1=0.05*Det+eth;
T2=0.1*Det+eth;
[voiceseg,vsl,SF,NF]=vad_param1D(Enm,T1,T2); % 用能熵比法的双门限端点检测

% 作图
top=Det*1.1+eth;
botton=eth-0.1*Det;
subplot 311; 
plot(time,x,'k'); hold on
title('语音波形');
ylabel('幅值'); axis([0 max(time) -1 1]);
subplot 312; 
plot(time,signal,'k'); hold on
title(['带噪语音波形 SNR=' num2str(SNR) 'dB'] );
ylabel('幅值'); axis([0 max(time) -1 1]);
subplot 313; plot(frameTime,Enm,'k');  axis([0 max(time) botton top]); 
line([0,frameTime(fn)], [T1 T1], 'color','k','LineStyle','--');
line([0,frameTime(fn)], [T2 T2], 'color','k','LineStyle','-');
title('短时能熵比'); xlabel('时间/s');
for k=1 : vsl                           % 标出语音端点
    nx1=voiceseg(k).begin; nx2=voiceseg(k).end;
    fprintf('%4d   %4d   %4d\n',k,nx1,nx2);
    subplot 311
    line([frameTime(nx1) frameTime(nx1)],[-1 1],'color','k','linestyle','-');
    line([frameTime(nx2) frameTime(nx2)],[-1 1],'color','k','linestyle','--');
    subplot 313
    line([frameTime(nx1) frameTime(nx1)],[botton top],'color','k','linestyle','-');
    line([frameTime(nx2) frameTime(nx2)],[botton top],'color','k','linestyle','--');
end

