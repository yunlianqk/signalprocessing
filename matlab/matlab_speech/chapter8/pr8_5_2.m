% 
% pr8_5_2 
clc; close all; clear all;

run Set_II;                               % 参数设置
run Part_II;                              % 读入文件,分帧和端点检测
% 数字带通滤波器的设计
Rp=1; Rs=50; fs2=fs/2;                    % 通带波纹1dB,阻带衰减50dB 
Wp=[60 500]/fs2;                          % 通带为60～500Hz
Ws=[20 1000]/fs2;                         % 阻带为20和1000Hz
[n,Wn]=ellipord(Wp,Ws,Rp,Rs);             % 选用椭圆滤波器
[b,a]=ellip(n,Rp,Rs,Wn);                  % 求出滤波器系数
x1=filter(b,a,x);                         % 带通滤波
x1=x1/max(abs(x1));                       % 幅值归一化
x2=resample(x1,1,4);                      % 按4:1降采样率

lmin=fix(fs/500);                         % 基音周期的最小值
lmax=fix(fs/60);                          % 基音周期的最大值
period=zeros(1,fn);                       % 基音周期初始化
wind=hanning(wlen/4);                     % 窗函数
y2=enframe(x2,wind,inc/4)';               % 再一次分帧
p=4;                                      % LPC阶数为4
for i=1 : vosl                            % 只对有话段数据处理
    ixb=voiceseg(i).begin;                % 取一段有话段
    ixe=voiceseg(i).end;                  % 求取该有话段开始和结束位置及帧数
    ixd=ixe-ixb+1;
    for k=1 : ixd                         % 对该段有话段数据处理
        u=y2(:,k+ixb-1);                  % 取来一帧数据
        ar = lpc(u,p);                    % 计算LPC系数
        z = filter([0 -ar(2:end)],1,u);   % 一帧数据LPC逆滤波输出
        E = u - z;                        % 预测误差
        ru1= xcorr(E, 'coeff');           % 计算归一化自相关函数
        ru1 = ru1(wlen/4:end);            % 取延迟量为正值的部分
        ru=resample(ru1,4,1);             % 按1:4升采样率
        [tmax,tloc]=max(ru(lmin:lmax));   % 在Pmin～Pmax范围内寻找最大值
        period(k+ixb-1)=lmin+tloc-1;      % 给出对应最大值的延迟量
    end
end
T1=pitfilterm1(period,voiceseg,vosl);     % 基音周期平滑处理
% 作图
subplot 211, plot(time,x,'k');  title('语音信号')
axis([0 max(time) -1 1]); grid;  ylabel('幅值'); xlabel('时间/s');
subplot 212; hold on
line(frameTime,period,'color',[.6 .6 .6],'linewidth',2); 
xlim([0 max(time)]); title('基音周期'); grid; 
ylim([0 150]);  ylabel('样点数'); xlabel('时间/s'); 
plot(frameTime,T1,'k'); hold off
legend('初估算值','平滑后值'); box on

