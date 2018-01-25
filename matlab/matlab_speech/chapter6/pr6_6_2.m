%
% pr6_6_2 
clear all; clc; close all

run Set_I                               % 基本设置
run PART_I                              % 读入数据，分帧等准备
df=fs/wlen;                             % 求出FFT后频率分辨率
fx1=fix(250/df)+1; fx2=fix(3500/df)+1;  % 找出250Hz和3500Hz的位置
km=floor(wlen/8);                       % 计算出子带个数
K=0.5;                                  % 常数K
for i=1:fn
    A=abs(fft(y(:,i)));                 % 取来一帧数据FFT后取幅值
    E=zeros(wlen/2+1,1);            
    E(fx1+1:fx2-1)=A(fx1+1:fx2-1);      % 只取250～3500Hz之间的分量
    E=E.*E;                             % 计算能量
    P1=E/sum(E);                        % 幅值归一化
    index=find(P1>=0.9);                % 寻找是否有分量的概率大于0.9
    if ~isempty(index), E(index)=0; end % 若有,该分量置0
    for m=1:km                          % 计算子带能量
        Eb(m)=sum(E(4*m-3:4*m));
    end
    prob=(Eb+K)/sum(Eb+K);              % 计算子带概率
    Hb(i) = -sum(prob.*log(prob+eps));  % 计算子带谱熵
end   
Enm=multimidfilter(Hb,10);              % 平滑处理
Me=min(Enm);                            % 设置阈值
eth=mean(Enm(1:NIS));
Det=eth-Me;
T1=0.99*Det+Me;
T2=0.96*Det+Me;
[voiceseg,vsl,SF,NF]=vad_param1D_revr(Enm,T1,T2);% 用双门限法反向端点检测  
% 作图
top=Det*1.1+Me;
botton=Me-0.1*Det;
subplot 311; 
plot(time,x,'k'); hold on
title('语音波形');
ylabel('幅值'); axis([0 max(time) -1 1]);
subplot 312; 
plot(time,signal,'k'); hold on
title(['带噪语音波形 SNR=' num2str(SNR) 'dB'] );
ylabel('幅值'); axis([0 max(time) -1 1]);
subplot 313; plot(frameTime,Enm,'k');  axis([0 max(time) botton top]); 
line([0 fn],[T1 T1],'color','k','LineStyle','--');
line([0 fn],[T2 T2],'color','k','LineStyle','-');
title('短时改进子带谱熵'); xlabel('时间/s'); ylabel('谱熵值');
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

