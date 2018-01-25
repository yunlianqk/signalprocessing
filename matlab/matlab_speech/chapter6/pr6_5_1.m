%
% pr6_5_1 
clear all; clc; close all;

run Set_I                               % 基本设置
run PART_I                              % 读入数据，分帧等准备
Y=fft(y);                               % FFT变换
Y=abs(Y(1:fix(wlen/2)+1,:));            % 计算正频率幅值
N=mean(Y(:,1:NIS),2);                   % 计算前导无话段噪声区平均频谱
NoiseCounter=0;

for i=1:fn, 
    if i<=NIS                           % 在前导无话段中设置为NF=1,SF=0
        SpeechFlag=0;
        NoiseCounter=100;
        SF(i)=0;
        NF(i)=1;
    else                                % 检测每帧计算对数频谱距离
        [NoiseFlag, SpeechFlag, NoiseCounter, Dist]=vad(Y(:,i),N,NoiseCounter,2.5,8); 
        SF(i)=SpeechFlag;
        NF(i)=NoiseFlag;
        D(i)=Dist;
    end
end
sindex=find(SF==1);                     % 从SF中寻找出端点的参数完成端点检测
voiceseg=findSegment(sindex);
vosl=length(voiceseg);
% 作图
subplot 311; plot(time,x,'k'); 
title('纯语音波形');
ylabel('幅值'); ylim([-1 1]);
subplot 312; plot(time,signal,'k');
title(['带噪语音 SNR=' num2str(SNR) '(dB)'])
ylabel('幅值'); ylim([-1.2 1.2]);
subplot 313; plot(frameTime,D,'k'); 
xlabel('时间/s'); ylabel('幅值'); 
title('对数频谱距离'); ylim([0 8]);

for k=1 : vosl                           % 标出语音端点
    nx1=voiceseg(k).begin; nx2=voiceseg(k).end;
    fprintf('%4d   %4d   %4d\n',k,nx1,nx2);
    subplot 311
    line([frameTime(nx1) frameTime(nx1)],[-1 1],'color','k','linestyle','-');
    line([frameTime(nx2) frameTime(nx2)],[-1 1],'color','k','linestyle','--');
    subplot 313
    line([frameTime(nx1) frameTime(nx1)],[0 8],'color','k','linestyle','-');
    line([frameTime(nx2) frameTime(nx2)],[0 8],'color','k','linestyle','--');
end
