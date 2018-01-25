%
% pr6_9_2   
clear all; clc; close all;

run Set_I                               % 基本设置
SNR=0;                                  % 重新设置信噪比SNR
run PART_I                              % 读入数据,分帧等准备
snr1=SNR_singlech(x,signal)             % 计算初始信噪比值
a=3; b=0.01;
output=simplesubspec(signal,wlen,inc,NIS,a,b);  % 计算谱减
snr2=SNR_singlech(x,output)             % 计算谱减后信噪比值
y=enframe(output,wlen,inc)';            % 谱减后输出序列分帧
nl2=wlen/2+1;
Y=fft(y);                               % FFT转成频域
Y_abs=abs(Y(1:nl2,:));                  % 取正频率域幅值
M=floor(nl2/4);                         % 计算子带数
for k=1 : fn
    for i=1 : M                         % 每个子带由4条谱线相加
        j=(i-1)*4+1;
        SY(i,k)=Y_abs(j,k)+Y_abs(j+1,k)+Y_abs(j+2,k)+Y_abs(j+3,k);
    end
    Dvar(k)=var(SY(:,k));               % 计算每帧子带分离的频带方差
end
Dvarm=multimidfilter(Dvar,10);          % 平滑处理
dth=max(Dvarm(1:(NIS)));                % 阈值计算
T1=1.5*dth;
T2=3*dth;
[voiceseg,vsl,SF,NF]=vad_param1D(Dvarm,T1,T2);% 频域方差双门限的端点检测

% 作图
pos = get(gcf,'Position');
set(gcf,'Position',[pos(1), pos(2)-150,pos(3),pos(4)+100]) 
subplot 411; plot(time,x,'k'); axis tight;
title('纯语音波形'); ylabel('幅值'); xlabel('(a)');
subplot 412; plot(time,signal,'k'); axis tight; xlabel('(b)');
title(['带噪语音 信噪比=' num2str(SNR) 'dB']); ylabel('幅值')
subplot 413; plot(time,output,'k'); xlabel('(c)');
title(['谱减后语音波形 SNR=' num2str(round(snr2*100)/100) 'dB'] ); 
ylabel('幅值')
subplot 414; plot(frameTime,Dvarm,'k');
title('谱减短时均匀子带频带方差值'); 
xlabel(['时间/s' 10 '(d)']);  ylabel('方差值');
line([0,frameTime(fn)], [T1 T1], 'color','k','LineStyle','--');
line([0,frameTime(fn)], [T2 T2], 'color','k','LineStyle','-');
ylim([0 max(Dvar)]);
for k=1 : vsl
    nx1=voiceseg(k).begin; nx2=voiceseg(k).end;
    fprintf('%4d   %4d   %4d\n',k,nx1,nx2);
    subplot 411; 
    line([frameTime(nx1) frameTime(nx1)],[-1 1],'color','k','LineStyle','-');
    line([frameTime(nx2) frameTime(nx2)],[-1 1],'color','k','LineStyle','--');
    subplot 414; 
    line([frameTime(nx1) frameTime(nx1)],[0 max(Dvar)],'color','k','LineStyle','-');
    line([frameTime(nx2) frameTime(nx2)],[0 max(Dvar)],'color','k','LineStyle','--');
end



        
