%
% pr8_7_3   
clear all; clc; close all;

filedir=[];                               % 设置语音文件路径
filename='tone4.wav';                     % 设置文件名
fle=[filedir filename]                    % 构成路径和文件名的字符串
SNR=0;                                    % 设置信噪比
IS=0.15;                                  % 设置前导无话段长度
wlen=240;                                 % 设置帧长为25ms
inc=80;                                   % 设置帧移10ms
[xx,fs]=wavread(fle);                     % 读入数据
xx=xx-mean(xx);                           % 消除直流分量
x=xx/max(abs(xx));                        % 幅值归一化
N=length(x);
time=(0:N-1)/fs;                          % 设置时间
lmin=floor(fs/500);                       % 最高基音频率500Hz对应的基音周期
lmax=floor(fs/60);                        % 最高基音频率60Hz对应的基音周期 
signal=Gnoisegen(x,SNR);                  % 叠加噪声
overlap=wlen-inc;                         % 求重叠区长度
NIS=fix((IS*fs-wlen)/inc +1);             % 求前导无话段帧数
snr1=SNR_singlech(x,signal)               % 计算初始信噪比值
a=3; b=0.01;                              % 设置a和b
output=simplesubspec(signal,wlen,inc,NIS,a,b);% 谱减法减噪
snr2=SNR_singlech(x,output)               % 计算谱减后信噪比值
yy  = enframe(output,wlen,inc)';          % 滤波后信号分帧
time = (0 : length(x)-1)/fs;              % 计算时间坐标
fn=size(yy,2);
frameTime=frame2time(fn,wlen,inc,fs);

Thr1=0.12;                                % 设置端点检测阈值
r2=0.5;                                   % 设置元音主体检测的比例常数
ThrC=[10 15];                             % 设置相邻基音周期间的阈值
% 用于基音检测的端点检测和元音主体检测
[voiceseg,vosl,vseg,vsl,Thr2,Bth,SF,Ef]=pitch_vads(yy,fn,Thr1,r2,10,8);
% 60～500Hz的带通滤波器系数
b=[0.012280   -0.039508   0.042177   0.000000   -0.042177   0.039508   -0.012280];
a=[1.000000   -5.527146   12.854342   -16.110307   11.479789   -4.410179   0.713507];
x=filter(b,a,xx);                         % 数字滤波
x=x/max(abs(x));                          % 幅值归一化
y=enframe(x,wlen,inc)';                   % 第二次分帧
lmax=floor(fs/60);                        % 基音周期的最小值
lmin=floor(fs/500);                       % 基音周期的最大值
[Extseg,Dlong]=Extoam(voiceseg,vseg,vosl,vsl,Bth);% 计算延伸区间和延伸长度
T1=ACF_corrbpa(y,fn,vseg,vsl,lmax,lmin,ThrC(1));  % 对元音主体进行基音检测
% 对语音主体的前后向过渡区延伸基音检测        
T0=zeros(1,fn);                           % 初始化
F0=zeros(1,fn);
for k=1 : vsl                             % 共有vsl个元音主体
    ix1=vseg(k).begin;                    % 第k个元音主体开始位置
    ix2=vseg(k).end;                      % 第k个元音主体结束位置
    in1=Extseg(k).begin;                  % 第k个元音主体前向延伸开始位置
    in2=Extseg(k).end;                    % 第k个元音主体后向延伸结束位置
    ixl1=Dlong(k,1);                      % 前向延伸长度
    ixl2=Dlong(k,2);                      % 后向延伸长度
    if ixl1>0                             % 需要前向延伸基音检测
        [Bt,voiceseg]=back_Ext_shtpm1(y,fn,voiceseg,Bth,ix1,...
        ixl1,T1,k,lmax,lmin,ThrC);
    else                                  % 不需要前向延伸基音检测
        Bt=[];
    end
    if ixl2>0                             % 需要后向延伸基音检测
        [Ft,voiceseg]=fore_Ext_shtpm1(y,fn,voiceseg,Bth,ix2,...
        ixl2,vsl,T1,k,lmax,lmin,ThrC);
    else                                  % 不需要后向延伸基音检测
        Ft=[];
    end
    T0(in1:in2)=[Bt T1(ix1:ix2) Ft];      % 第k个元音主体完成了前后向延伸检测 
end
tindex=find(T0>lmax);                     % 限止延伸后最大基音周期值不超越lmax
T0(tindex)=lmax;
tindex=find(T0<lmin & T0~=0);             % 限止延伸后最小基音周期值不低于lmin
T0(tindex)=lmin;
tindex=find(T0~=0);
F0(tindex)=fs./T0(tindex);                 % 求出基音频率
TT=pitfilterm1(T0,Extseg,vsl);             % T0平滑滤波
FF=pitfilterm1(F0,Extseg,vsl);             % F0平滑滤波
% STFT分析,绘制语谱图
nfft=512;
d=stftms(xx,wlen,nfft,inc);
W2=1+nfft/2;
n2=1:W2;
freq=(n2-1)*fs/nfft;
% 作图
pos = get(gcf,'Position');
set(gcf,'Position',[pos(1), pos(2)-150,pos(3),pos(4)+150]);
subplot 611; plot(time,xx,'k'); ylabel('幅值');
title('原始信号'); axis([0 max(time) -1 1]);
for k=1 : vosl
        line([frameTime(voiceseg(k).begin) frameTime(voiceseg(k).begin)],...
        [-1 1],'color','k');
        line([frameTime(voiceseg(k).end) frameTime(voiceseg(k).end)],...
        [-1 1],'color','k','linestyle','--');
end
subplot 612; plot(time,signal,'k'); ylabel('幅值');
title('带噪信号'); axis([0 max(time) -1 1]);
subplot 613; plot(time,output,'k'); ylabel('幅值');
title('消噪信号'); axis([0 max(time) -1 1]);
subplot 614; plot(frameTime,Ef,'k'); hold on; ylabel('幅值');
title('能熵比'); axis([0 max(time) 0 max(Ef)]);
line([0 max(frameTime)],[Thr1 Thr1],'color','k','linestyle','--');
plot(frameTime,Thr2,'k','linewidth',2);
for k=1 : vsl
        line([frameTime(vseg(k).begin) frameTime(vseg(k).begin)],...
        [0 max(Ef)],'color','k','linestyle','-.');
        line([frameTime(vseg(k).end) frameTime(vseg(k).end)],...
        [0 max(Ef)],'color','k','linestyle','-.');
end
text(3.2,0.2,'Thr1');
text(2.9,0.55,'Thr2');
subplot 615; plot(frameTime,TT,'k'); ylabel('样点数'); 
title('基音周期'); grid; axis([0 max(time) 0 80]);
subplot 616; plot(frameTime,FF,'k'); ylabel('频率/Hz'); 
title('基音频率'); grid; axis([0 max(time) 0 350]); xlabel('时间/s'); 

figure(2)
pos = get(gcf,'Position');
set(gcf,'Position',[pos(1), pos(2)-100,pos(3),(pos(4)-240)]);
imagesc(frameTime,freq,abs(d(n2,:)));  axis xy
m = 64; LightYellow = [0.6 0.6 0.6];
MidRed = [0 0 0]; Black = [0.5 0.7 1];
Colors = [LightYellow; MidRed; Black];
colormap(SpecColorMap(m,Colors));
hold on
plot(frameTime,FF,'w');
ylim([0 1000]);
title('语谱图上的基音频率曲线');
xlabel('时间/s'); ylabel('频率/Hz')
