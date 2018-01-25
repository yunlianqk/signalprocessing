%
% pr6_9_1 
clear all; clc; close all;

filedir=[];                             % 设置文件路径
filename='bluesky1.wav';                % 设置文件名称
fle=[filedir filename]                  % 构成文件路径和名称
[xx,fs]=wavread(fle);                   % 读入数据
x=xx/max(abs(xx));                      % 幅值归一化
N=length(x);
time=(0:N-1)/fs;                        % 设置时间
IS=0.3;                                 % 设置前导无话段长度
wlen=200;                               % 设置帧长为25ms
inc=80;                                 % 求帧移
SNR=20;                                 % 设置信噪比
wnd=hamming(wlen);                      % 设置窗函数
overlap=wlen-inc;                       % 求重叠区长度
NIS=fix((IS*fs-wlen)/inc +1);           % 求前导无话段帧数


noisefile='destroyerops.wav';           % 指定噪声的文件名
[signal,noise] = add_noisefile(x,noisefile,SNR,fs);% 叠加噪声
y=enframe(signal,wnd,inc)';             % 分帧
fn=size(y,2);                           % 求帧数
frameTime=frame2time(fn, wlen, inc, fs);

Y=fft(y);                               % FFT
Y=abs(Y(1:fix(wlen/2)+1,:));            % 计算正频率幅值
N=mean(Y(:,1:NIS),2);                   % 计算前导无话段噪声区平均频谱
NoiseCounter=0;
NoiseLength=9;

for i=1:fn, 
    if i<=NIS                           % 在前导无话段中设置为NF=1,SF=0
        SpeechFlag=0;
        NoiseCounter=100;
        SF(i)=0;
        NF(i)=1;
        TNoise(:,i)=N;
    else                                % 检测每帧计算对数频谱距离
        [NoiseFlag, SpeechFlag, NoiseCounter, Dist]=...
            vad(Y(:,i),N,NoiseCounter,2.5,8); 
        SF(i)=SpeechFlag;
        NF(i)=NoiseFlag;
        D(i)=Dist;
        if SpeechFlag==0                % 如果是噪声段对噪声谱进行更新
            N=(NoiseLength*N+Y(:,i))/(NoiseLength+1); %
            
        end
        TNoise(:,i)=N;
    end
    SN(i)=sum(TNoise(:,i));             % 计算噪声谱幅值之和
end
% 作图
pos = get(gcf,'Position');
set(gcf,'Position',[pos(1), pos(2)-100,pos(3),pos(4)+100]) 
subplot 411; plot(time,x,'k',frameTime,SF,'k--'); 
title('纯语音波形');
ylabel('幅值'); ylim([-1.2 1.2]);
subplot 412; plot(time,signal,'k');
title(['带噪语音 SNR=' num2str(SNR) '(dB)'])
ylabel('幅值'); ylim([-1.5 1.5]);
subplot 413; plot(frameTime,D,'k'); 
ylabel('幅值'); grid;
title('对数频谱距离'); ylim([0 25]);
subplot 414; plot(frameTime,SN,'k','linewidth',2); 
xlabel('时间/s'); ylabel('幅值'); grid;
title('噪声幅值和');  ylim([7 10]);

