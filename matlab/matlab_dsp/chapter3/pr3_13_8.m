%
% pr3_13_8 
clear all; clc; close all;

Fs=10;                            % 采样频率
fp1=1.5; fp2=2.5;                 % 通带和阻带频率
fs1=1; fs2=3;
Rp=2; As=80;                      % 设置Rp和As
wp1=2*fp1/Fs;wp2=2*fp2/Fs;        % 归一化角频率
ws1=2*fs1/Fs; ws2=2*fs2/Fs;
F=[ws1 wp1 wp2 ws2];              % 给出频率矢量F
devp=(10^(Rp/20)-1)/(10^(Rp/20)+1); % 计算波纹和衰减线性值
devs=10^(-As/20); 
dev=[devs devp devs];             % 设置偏离值
A=[0 1 0];                        % 设置带通或带阻，1为带通，0为带阻 

[N,F0,A0,W]=firpmord(F,A,dev,2);  % 调用firpmord函数计算参数
N=N+mod(N,2);                     % 保证滤波器阶数为偶数
Acs=1;                            % Acs初始化
dw=1/500;                         % 角频率分辨率
ns1=floor(ws1/dw)-1;              % 阻带对应的样点
ns2=floor(ws2/dw)+1; 
np1=floor(wp1/dw)-1;               % 通带对应的样点
np2=floor(wp2/dw)+1;
wlip=np1:np2;                      % 通带样点区间
wlis1=1:ns1;                       % 阻带样点区间
wlis2=ns2:501;
while Acs>-As                      % 阻带衰减不满足条件将循环
    h=firpm(N,F0,A0,W);            % 用firpm函数设计滤波器
    [db, mag, pha, grd,w]=freqz_m(h,1);  % 计算滤波器频域响应
    Acs1=max(db(wlis1));          % 求阻带衰减值
    Acs2=max(db(wlis2));
    Acs=max(Acs1,Acs2);
    fprintf('N=%4d   As=%5.2f\n',N,-Acs); % 显示滤波器阶数和衰减值
    N=N+2;                        % 阶数加2,保证为第1类滤波器
end
N=N-2;                            % 修正N值
[Hr,w,P,L,type] = ampl_ress(h);   % 计算滤波器的振幅响应
figure(2)
plot(w/pi*Fs/2,db,'k'); grid;
title('等波纹带通滤波器的幅值响应');
xlabel('频率/Hz'); ylabel('幅值/dB')
set(gcf,'color','w');
