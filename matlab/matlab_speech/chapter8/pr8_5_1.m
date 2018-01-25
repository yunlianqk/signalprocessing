% 
% pr8_5_1 
clc; close all; clear all;

run Set_II;                                 % 参数设置
run Part_II;                                % 读入文件,分帧和端点检测

lmin=fix(fs/500);                           % 基音周期的最小值
lmax=fix(fs/60);                            % 基音周期的最大值
period=zeros(1,fn);                         % 基音周期初始化
p=12;                                       % 设置线性预测阶数
for k=1:fn 
    if SF(k)==1                             % 是否在有话帧中
        u=y(:,k).*hamming(wlen);            % 取来一帧数据加窗函数
        ar = lpc(u,p);                      % 计算LPC系数
        z = filter([0 -ar(2:end)],1,u);     % 一帧数据LPC逆滤波输出
        E = u - z;                          % 预测误差
        xx=fft(E);                          % FFT
        a=2*log(abs(xx)+eps);               % 取模值和对数
        b=ifft(a);                          % 求取倒谱 
        [R(k),Lc(k)]=max(b(lmin:lmax));     % 在Pmin～Pmax区间寻找最大值
        period(k)=Lc(k)+lmin-1;             % 给出基音周期
    end
end
T1=pitfilterm1(period,voiceseg,vosl);       % 基音周期平滑处理

% 作图
subplot 211, plot(time,x,'k');  title('语音信号')
axis([0 max(time) -1 1]); grid;  ylabel('幅值'); xlabel('时间/s');
subplot 212; hold on
line(frameTime,period,'color',[.6 .6 .6],'linewidth',2); 
axis([0 max(time) 0 150]); title('基音周期'); 
ylabel('样点数'); xlabel('时间/s'); grid; 
plot(frameTime,T1,'k'); hold off
legend('初估算值','平滑后值'); box on;
