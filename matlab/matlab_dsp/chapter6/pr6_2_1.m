%
% pr6_2_1 
clear all; clc; close all;

xx=load('uy_25a.txt');                 % 读入数据文件
t=xx(:,1); x=xx(:,2);                  % 得到时间序列和信号序列
dt=t(2)-t(1); fs=1/dt;                 % 求出采样频率
N=length(x);                           % 数据长度
y=x;                                   % 保存原始信号在y中
n=1:N; n2=1:N/2+1;                     % 设置n和n2
df=fs/N;                               % 给出频率分辨率
freq=(n2-1)*df;                        % 给出频率刻度
Y=fft(y);                              % 给出原始信号的频谱

rad=pi/180;                            % 1弧度值
DX=[5 15];                             % 寻找基波的区间
t=(0:N-1)/fs;                          % 设置时间刻度
for k=1 : 99                           % 求基波及2~99阶谐波的参数
    if k==1;                           % 当k为1,即求基波参数
        NX=DX;                         % 给出寻找基波的区间
        Z=specor_m1(x,fs,N,NX,2);      % 比值校正法求出基波的参数
        u=Z(2)*cos(2*pi*Z(1)*t+Z(3));  % 仿真出基波信号
        x=x'-u;                        % 从原始信号中减去基波的成分
        f0=Z(1);                       % 基波的频率
    else                               % 求2~99阶谐波的参数
        NX=[k*f0-DX(1) k*f0+DX(1)];    % 给出寻找k阶谐波的频率区间
        Z=specor_m1(x,fs,N,NX,2);      % 比值校正法求出k阶谐波的参数
        u=Z(2)*cos(2*pi*Z(1)*t+Z(3));  % 仿真出k阶谐波信号
        x=x-u;                         % 从原始信号中减去k阶谐波的成分
    end
end
X=fft(x);                              % 消除正弦信号后的频谱
% 作图
figure(1);
subplot 211; plot(t,y,'k')
axis([0 5 -2e-3 2e-3]); title('处理前信号的时域波形');
xlabel('时间/s'); ylabel('幅值');
subplot 212; plot(freq,10*log10(abs(Y(n2))),'k');  
axis([0 1000 -40 10]); title('处理前信号的频谱图');
xlabel('频率/Hz'); ylabel('幅值/dB'); grid;
set(gcf,'color','w'); 

figure(2);
subplot 211; plot(t,x,'k')
axis([0 5 -1.2e-3 1e-3]); title('处理后信号的时域波形');
xlabel('时间/s'); ylabel('幅值');
subplot 212; plot(freq,10*log10(abs(X(n2))),'k'); 
axis([0 1000 -40 10]); title('处理后信号的频谱图');
xlabel('频率/Hz'); ylabel('幅值/dB'); grid;
set(gcf,'color','w'); 

    

    
    


