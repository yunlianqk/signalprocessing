%
% pr3_13_7  
clear all; clc; close all;

Fs=2000;                          % 采样频率
Fs2=Fs/2;                         % 奈奎斯特频率
fp=200; fs=300;                   % 通带和阻带频率
wp=fp*pi/Fs2; ws=fs*pi/Fs2;       % 通带和阻带归一化角频率
Rp=2; As=40;                      % 通带波纹和阻带衰减
F=[wp ws]/pi;                     % 理想滤波器的频率矢量
A=[1,0];                          % 理想滤波器的幅值矢量
% 通带波纹和阻带衰减线性值
devp=(10^(Rp/20)-1)/(10^(Rp/20)+1); devs=10^(-As/20); 
dev=[devp,devs];                  % 与理想滤波器的偏差的矢量

[N,F0,A0,W]=firpmord(F,A,dev);    % 调用firpmord函数计算参数
N=N+mod(N,2);                     % 保证滤波器阶数为偶数
Acs=1;                            % Acs初始化
dw=pi/500;                        % 角频率分辨率
ns1=floor(ws/dw)+1;               % 通带对应的样点
np1=floor(wp/dw)-1;               % 阻带对应的样点
wlip=1:np1;                       % 通带样点区间
wlis=ns1:501;                     % 阻带样点区间

while Acs>-As                     % 阻带衰减不满足条件将循环
    h=firpm(N,F0,A0,W);           % 用firpm函数设计滤波器
    [db, mag, pha, grd,w]=freqz_m(h,1);  % 计算滤波器频域响应
    Acs=max(db(wlis));            % 求阻带衰减值
    fprintf('N=%4d   As=%5.2f\n',N,-Acs); % 显示滤波器阶数和衰减值
    N=N+2;                        % 阶数加2,保证为第1类滤波器
end
N=N-2;                            % 修正N值
[Hr,w,P,L,type] = ampl_ress(h);   % 计算滤波器的振幅响应
% 作图
subplot 221; plot(w/pi*Fs2/1000,db,'k','linewidth',2); 
title('等波纹滤波器幅值响应'); 
xlabel('频率/kHz'); ylabel('幅值/dB')
grid; axis([0 1 -100 10]);
set(gca,'XTickMode','manual','XTick',[0,0.2,0.3,1])
set(gca,'YTickMode','manual','YTick',[-40,0])
L=0:N;
subplot 223; stem(L,h,'k'); axis([-1,N,-0.1,0.3]); grid;
title('滤波器脉冲响应');xlabel('样点'); ylabel('幅值');
subplot 222; plot(w/pi*Fs2/1000,Hr,'k','linewidth',2);
title('等波纹滤波器振幅响应');  grid;
xlabel('频率/kHz'); ylabel('振幅值')
set(gca,'XTickMode','manual','XTick',[0,0.2,0.3,1])
set(gca,'YTickMode','manual','YTick',[0,0.89,1.11])
subplot 224; plot(wlip/500,Hr(wlip)-1,'k','linewidth',2); hold on
plot(wlis/500,Hr(wlis),'k','linewidth',2);
title('通带和阻带波纹振幅值'); 
xlabel('频率/kHz'); ylabel('振幅值')
xlim([0 1]); grid;
set(gca,'XTickMode','manual','XTick',[0,0.2,0.3,1])
set(gca,'YTickMode','manual','YTick',[-0.11,-0.01,0,0.01,0.11]);
set(gcf,'color','w');


