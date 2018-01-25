% 
% pr8_7_1   
clc; close all; clear all;

filedir=[];                             % 设置数据文件的路径
filename='tone4.wav';                   % 设置数据文件的名称
fle=[filedir filename]                  % 构成路径和文件名的字符串
[xx,fs]=wavread(fle);                   % 读取文件
xx=xx-mean(xx);                         % 消除直流分量
xx=xx/max(abs(xx));                     % 幅值归一化
SNR=5;                                  % 设置信噪比
x=Gnoisegen(xx,SNR);                    % 叠加噪声
wlen=320;  inc=80;                      % 帧长和帧移
overlap=wlen-inc;                       % 两帧重叠长度 
N=length(x);                            % 信号长度
time=(0:N-1)/fs;                        % 设置时间

y=enframe(x,wlen,inc)';                 % 第一次分帧
fn=size(y,2);                           % 取来帧长
frameTime = frame2time(fn, wlen, inc, fs);  % 计算每一帧对应的时间
T1=0.23;                                % 设置T1
[voiceseg,vsl,SF,Ef]=pitch_vad1(y,fn,T1); % 基音的端点检测
% 60～500Hz的带通滤波器系数
b=[0.012280   -0.039508   0.042177   0.000000   -0.042177   0.039508   -0.012280];
a=[1.000000   -5.527146   12.854342   -16.110307   11.479789   -4.410179   0.713507];
z=filter(b,a,x);                        % 带通数字滤波
yy  = enframe(z,wlen,inc)';             % 滤波后信号分帧

lmin=floor(fs/500);                     % 基音周期的最小值
lmax=floor(fs/60);                      % 基音周期的最大值
period=zeros(1,fn);                     % 基音周期初始化
F0=zeros(1,fn);                         % 初始化 
period=Wavelet_corrm1(yy,fn,voiceseg,vsl,lmax,lmin); % 小波-自相关函数基音检测
tindex=find(period~=0);
F0(tindex)=fs./period(tindex);          % 求出基音频率
TT=pitfilterm1(period,voiceseg,vsl);    % 平滑处理
FF=pitfilterm1(F0,voiceseg,vsl);        % 平滑处理
% 作图
pos = get(gcf,'Position');
set(gcf,'Position',[pos(1), pos(2)-150,pos(3),pos(4)+100]);
subplot 511; plot(time,xx,'k');
axis([0 max(time) -1 1]); title('原始语音'); ylabel('幅值');
for k=1 : vsl
    line([frameTime(voiceseg(k).begin) frameTime(voiceseg(k).begin)],...
    [-1 1],'color','k','linestyle','-');
    line([frameTime(voiceseg(k).end) frameTime(voiceseg(k).end)],...
    [-1 1],'color','k','linestyle','--');
end
subplot 512; plot(frameTime,Ef,'k')
line([0 max(frameTime)],[T1 T1],'color','k','linestyle','-.');
text(3.25, T1+0.05,'T1');
axis([0 max(time) 0 1]); title('能熵比'); ylabel('幅值')
for k=1 : vsl
    line([frameTime(voiceseg(k).begin) frameTime(voiceseg(k).begin)],...
    [-1 1],'color','k','linestyle','-');
    line([frameTime(voiceseg(k).end) frameTime(voiceseg(k).end)],...
    [-1 1],'color','k','linestyle','--');
end
subplot 513; plot(time,x,'k');  title('带噪语音')
axis([0 max(time) -1 1]); ylabel('幅值')
subplot 514; plot(frameTime,TT,'k','linewidth',2);
axis([0 max(time) 0 120]); title('基音周期'); grid; ylabel('样点数')
subplot 515; plot(frameTime,FF,'k','linewidth',2);
axis([0 max(time) 0 500]); title('基音频率'); 
grid; xlabel('时间/s');  ylabel('频率/Hz')
