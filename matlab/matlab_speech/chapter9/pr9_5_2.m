%
% pr9_5_2   
clear all; clc; close all;

Formant=[800 1200 3000;                          % 设置元音共振峰参数
    300 2300 3000;               
    350 650 2200];
Bwp=[150 200 250];                               % 三个共振峰滤波器的半带宽

filedir=[];                                      % 设置语音文件路径
filename='vowels8.wav';                          % 设置文件名
fle=[filedir filename]                           % 构成语音文件路径和文件名
[xx, fs, nbits]=wavread(fle);                    % 读入语音
x=filter([1 -.99],1,xx);                         % 预加重
wlen=200;                                        % 帧长
inc=80;                                          % 帧移
y=enframe(x,wlen,inc)';                          % 分帧
fn=size(y,2);                                    % 帧数
Nx=length(x);                                    % 数据长度
time=(0:Nx-1)/fs;                                % 时间刻度
frameTime=frame2time(fn,wlen,inc,fs);            % 每帧的时间刻度
T1=0.15; r2=0.5;                                 % 设置阈值
miniL=10;                                        % 有话段的最小帧数
[voiceseg,vosl,SF,Ef]=pitch_vad1(y,fn,T1,miniL); % 端点检测
FRMNT=ones(3,fn)*nan;                            % 初始化

for m=1 : vosl                                   % 对每一有话段处理
    Frt_cent=Formant(m,:);                       % 取共振峰中心频率
    in1=voiceseg(m).begin;                       % 有话段开始帧号
    in2=voiceseg(m).end;                         % 有话段结束帧号
    ind=in2-in1+1;                               % 有话段长度
    ix1=(in1-1)*inc+1;                           % 有话段在语音中的开始位置
    ix2=(in2-1)*inc+wlen;                        % 有话段在语音中的结束位置
    ixd=ix2-ix1+1;                               % 本有话段长度
    z=x(ix1:ix2);                                % 从语音中取来该有话段
    for kk=1 : 3                                 % 循环3次检测3个共振峰
        fw=Frt_cent(kk);                         % 取来对应的中心频率
        fl=fw-Bwp(kk);                           % 求出滤波器的低截止频率
        if fl<200, fl=200;   end
        fh=fw+Bwp(kk);                           % 求出滤波器的高截止频率
        b=fir1(100,[fl fh]*2/fs);                % 设计带通滤波器
        zz=conv(b,z);                            % 数字滤波
        zz=zz(51:51+ixd-1);                      % 延迟校正
        imp=emd(zz);                             % EMD变换
        impt=hilbert(imp(1,:)');                 % 希尔伯特变换
        fnor=instfreq(impt);                     % 提取瞬时频率              
        f0=[fnor(1); fnor; fnor(end)]*fs;        % 长度补齐
        val0=abs(impt);                          % 求模值
        for ii=1 : ind                           % 对每帧计算平均共振峰值
            ixb=(ii-1)*inc+1;                    % 该帧的开始位置
            ixe=ixb+wlen-1;                      % 该帧的结束位置
            u0=f0(ixb:ixe);                      % 取来该帧中的数据
            a0=val0(ixb:ixe);                    % 按式(9-5-17)计算
            a2=sum(a0.*a0);
            v0=sum(u0.*a0.*a0)/a2;
            FRMNT(kk,in1+ii-1)=v0;               % 赋值给FRMNT
        end
    end
end

%nfft=512;                                        % 计算语谱图
%d=stftms(x,wlen,nfft,inc);
%W2=1+nfft/2;
%n2=1:W2;
%freq=(n2-1)*fs/nfft;

% 作图
figure(1)                                        % 画信号的波形图和能熵比图
subplot 211; plot(time,xx,'k');
title('\a-i-u\三个元音的语音的波形图');
xlabel('时间/s'); ylabel('幅值'); xlim([0 max(time)]);
subplot 212; plot(frameTime,Ef,'k'); hold on
line([0 max(time)],[T1 T1],'color','k','linestyle','--');
title('归一化的能熵比图'); axis([0 max(time) 0 1.2]);
xlabel('时间/s'); ylabel('幅值')
for k=1 : vosl
    in1=voiceseg(k).begin;
    in2=voiceseg(k).end;
    it1=frameTime(in1);
    it2=frameTime(in2);
    line([it1 it1],[0 1.2],'color','k','linestyle','-.');
    line([it2 it2],[0 1.2],'color','k','linestyle','-.');
end

figure(2)                                        % 计算语谱图
nfft=512;
d=stftms(x,wlen,nfft,inc);
W2=1+nfft/2;
n2=1:W2;
freq=(n2-1)*fs/nfft;
imagesc(frameTime,freq,abs(d(n2,:)));  axis xy
m = 64; LightYellow = [0.6 0.6 0.6];
MidRed = [0 0 0]; Black = [0.5 0.7 1];
Colors = [LightYellow; MidRed; Black];
colormap(SpecColorMap(m,Colors));
hold on
plot(frameTime,FRMNT(1,:),'w',frameTime,FRMNT(2,:),'w',frameTime,FRMNT(3,:),'w')
title('语谱图叠加共振峰值');
xlabel('时间/s'); ylabel('频率/Hz');