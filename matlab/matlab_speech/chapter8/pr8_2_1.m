% 
% pr8_2_1  
clc; close all; clear all;

run Set_II;                                 % 参数设置
run Part_II;                                % 读入文件,分帧和端点检测
lmin=fix(fs/500);                           % 基音周期的最小值
lmax=fix(fs/60);                            % 基音周期的最大值
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
% 作图
subplot 211, plot(time,x,'k');  title('语音信号')
axis([0 max(time) -1 1]); ylabel('幅值');
subplot 212; plot(frameTime,period,'k');
xlim([0 max(time)]); title('基音周期'); 
grid; xlabel('时间/s'); ylabel('样点数');
for k=1 : vosl                              % 标出有话段
    nx1=voiceseg(k).begin;
    nx2=voiceseg(k).end;
    nxl=voiceseg(k).duration;
    fprintf('%4d   %4d   %4d   %4d\n',k,nx1,nx2,nxl);
    subplot 211
    line([frameTime(nx1) frameTime(nx1)],[-1 1],'color','k','linestyle','-');
    line([frameTime(nx2) frameTime(nx2)],[-1 1],'color','k','linestyle','--');
end
