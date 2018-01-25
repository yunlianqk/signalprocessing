%
% pr9_4_1  
clear all; clc; close all;

filedir=[];                                           % 设置数据文件的路径
filename='vowels8.wav';                               % 设置数据文件的名称
fle=[filedir filename]                                % 构成路径和文件名的字符串
[xx,fs]=wavread(fle);                                 % 读入语音文件
x=xx-mean(xx);                                        % 消除 直流分量
x=x/max(abs(x));                                      % 幅值归一化
y=filter([1 -.99],1,x);                               % 预加重
wlen=200;                                             % 设置帧长
inc=80;                                               % 设置帧移
xy=enframe(y,wlen,inc)';                              % 分帧
fn=size(xy,2);                                        % 求帧数
Nx=length(y);                                         % 数据长度
time=(0:Nx-1)/fs;                                     % 时间刻度
frameTime=frame2time(fn,wlen,inc,fs);                 % 每帧对应的时间刻度
T1=0.1;                                               % 设置阈值T1和T2的比例常数
miniL=20;                                             % 有话段的最小帧数
p=9; thr1=0.75;                                       % 线性预测阶数和阈值
[voiceseg,vosl,SF,Ef]=pitch_vad1(xy,fn,T1,miniL);     % 端点检测
Msf=repmat(SF',1,3);                                  % 把SF扩展为fn×3的数组
formant1=Ext_frmnt(xy,p,thr1,fs);                     % 提取共振峰信息

Fmap1=Msf.*formant1;                                  % 只取有话段的数据
findex=find(Fmap1==0);                                % 如果有数值为0 ,设为nan
Fmap=Fmap1;
Fmap(findex)=nan;

nfft=512;                                             % 计算语谱图
d=stftms(y,wlen,nfft,inc);
W2=1+nfft/2;
n2=1:W2;
freq=(n2-1)*fs/nfft;
warning off

% 作图
figure(1)                                             % 画信号的波形图和能熵比图
subplot 211; plot(time,x,'k');
title('\a-i-u\三个元音的语音的波形图');
xlabel('时间/s'); ylabel('幅值'); axis([0 max(time) -1.2 1.2]);
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

figure(2)                                             % 画语音信号的语谱图
imagesc(frameTime,freq,abs(d(n2,:)));  axis xy
m = 64; LightYellow = [0.6 0.6 0.6];
MidRed = [0 0 0]; Black = [0.5 0.7 1];
Colors = [LightYellow; MidRed; Black];
colormap(SpecColorMap(m,Colors)); hold on
plot(frameTime,Fmap,'w');                             % 叠加上共振峰频率曲线
title('在语谱图上标出共振峰频率');
xlabel('时间/s'); ylabel('频率/Hz')
