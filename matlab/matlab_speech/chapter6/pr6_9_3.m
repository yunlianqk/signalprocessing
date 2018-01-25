%
% pr6_9_3 
clear all; clc; close all

run Set_I                                   % 基本设置
SNR=0;                                      % 重新设置信噪比SNR
run PART_I                                  % 读入数据,分帧等准备
snr1=SNR_singlech(x,signal)                 % 计算加噪后的信噪比
alpha=2.8; beta=0.001; c=1;                 % 设置参数alpha,beta和c
% 调用多窗谱减函数Mtmpsd_ss,实现减噪处理
output=Mtmpsd_ssb(signal,wlen,inc,NIS,alpha,beta,c);  
snr2=SNR_singlech(x,output)                 % 计算减噪后的信噪比 

y=enframe(output,wlen,inc)';                % 对减噪后的信号分帧
aparam=2;                                   % 设置参数
for i=1:fn                                  % 计算各帧能熵比
    Sp = abs(fft(y(:,i)));                  % FFT变换取幅值
    Sp = Sp(1:wlen/2+1);	                % 只取正频率部分
    Esum(i) = log10(1+sum(Sp.*Sp)/aparam);  % 计算对数能量值
    prob = Sp/(sum(Sp));		            % 计算概率
    H(i) = -sum(prob.*log(prob+eps));       % 求谱熵值
    Ef(i) = sqrt(1 + abs(Esum(i)/H(i)));    % 计算能熵比
end   

Enm=multimidfilter(Ef,10);                  % 平滑滤波 
Me=max(Enm);                                % 取Enm的最大值
eth=mean(Enm(1:NIS));                       % 求均值eth
Det=Me-eth;                                 % 设置阈值
T1=0.05*Det+eth;
T2=0.1*Det+eth;
[voiceseg,vsl,SF,NF]=vad_param1D(Enm,T1,T2);% 用双门限法端点检测

% 作图
top=Det*1.1+eth;
botton=eth-0.1*Det;
pos = get(gcf,'Position');
set(gcf,'Position',[pos(1), pos(2)-200,pos(3),pos(4)+100])
subplot 411; 
plot(time,x,'k');
title('语音波形');
ylabel('幅值'); axis([0 max(time) -1 1]);
subplot 412; 
plot(time,signal,'k');
title(['带噪语音波形 SNR=' num2str(SNR) 'dB'] );
ylabel('幅值'); axis([0 max(time) -1 1]);
subplot 413; 
plot(time,output,'k');
title(['谱减后语音波形 SNR=' num2str(round(snr2*100)/100) 'dB'] );
ylabel('幅值'); axis([0 max(time) -1 1]);
subplot 414; plot(frameTime,Enm,'k');  axis([0 max(time) botton top]); 
title('短时能熵比'); xlabel('时间/s'); 
line([0 fn],[T1 T1],'color','k','linestyle','--');
line([0 fn],[T2 T2],'color','k','linestyle','-');

for k=1 : vsl
    nx1=voiceseg(k).begin; nx2=voiceseg(k).end;
    fprintf('%4d   %4d   %4d\n',k,nx1,nx2);
    subplot 411
    line([frameTime(nx1) frameTime(nx1)],[-1 1],'color','k','linestyle','-');
    line([frameTime(nx2) frameTime(nx2)],[-1 1],'color','k','linestyle','--');
    subplot 414
    line([frameTime(nx1) frameTime(nx1)],[botton top],'color','k','linestyle','-');
    line([frameTime(nx2) frameTime(nx2)],[botton top],'color','k','linestyle','--');
end


