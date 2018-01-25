% 
% pr8_2_2 
clc; close all; clear all;

run Set_II;                                 % 参数设置
run Part_II;                                % 读入文件,分帧和端点检测

lmin=fix(fs/500);                           % 基音周期提取中最小值
lmax=fix(fs/60);                            % 基音周期提取中最大值
period=zeros(1,fn);                         % 基音周期初始化
for k=1:fn 
    if SF(k)==1                             % 是否在有话帧中
        y1=y(:,k).*hamming(wlen);           % 取来一帧数据加窗函数
        xx=fft(y1);                         % FFT
        a=2*log(abs(xx)+eps);               % 取模值和对数
        b=ifft(a);                          % 求取倒谱 
        [R(k),Lc(k)]=max(b(lmin:lmax));     % 在lmin和lmax区间中寻找最大值
        period(k)=Lc(k)+lmin-1;             % 给出基音周期
    end
end

T0=zeros(1,fn);                             % 初始化T0和F0
F0=zeros(1,fn);
T0=pitfilterm1(period,voiceseg,vosl);       % 对T0进行平滑处理求出基音周期T0
Tindex=find(T0~=0);
F0(Tindex)=fs./T0(Tindex);                  % 求出基音频率F0
% 作图
subplot 311, plot(time,x,'k');  title('语音信号')
axis([0 max(time) -1 1]); grid;  ylabel('幅值');
subplot 312; line(frameTime,period,'color',[.6 .6 .6],'linewidth',3);
xlim([0 max(time)]); title('基音周期'); hold on;
ylim([0 150]); ylabel('样点数'); grid; 
for k=1 : vosl
    nx1=voiceseg(k).begin;
    nx2=voiceseg(k).end;
    nxl=voiceseg(k).duration;
    fprintf('%4d   %4d   %4d   %4d\n',k,nx1,nx2,nxl);
    subplot 311
    line([frameTime(nx1) frameTime(nx1)],[-1 1],'color','k','linestyle','-');
    line([frameTime(nx2) frameTime(nx2)],[-1 1],'color','k','linestyle','--');
end
subplot 312; plot(frameTime,T0,'k'); hold off
legend('平滑前','平滑后');
subplot 313; plot(frameTime,F0,'k'); 
grid; ylim([0 450]);
title('基音频率'); xlabel('时间/s'); ylabel('频率/Hz');


