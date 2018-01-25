%
% pr3_13_9 
clear all; clc; close all;

Fs=2000;                               % 采样频率
Fs2=Fs/2;                              % 奈奎斯特频率
% 滤波器各个频率点值
fc1=220; fc2=260; fc3=340; fc4=380; fc5=520;
fc6=560; fc7=640; fc8=680; fc9=820; fc10=860;
rp=1; as=40;                           % 通带波纹和阻带衰减 
% 归一化各频点值
Fc=[fc1 fc2 fc3 fc4 fc5 fc6 fc7 fc8 fc9 fc10]/Fs2;
% fir2法
f=[0 Fc 1];                            % 构成理想滤波器的频率矢量
a=[0 0 1 1 0 0 1 1 0 0 1 1];           % 构成理想滤波器的幅值矢量
dw=(fc3-fc2)*pi/Fs2;                   % 归一化的过渡带值
N1=ceil(6.6*pi/dw);                    % 计算海明窗时滤波器的阶数
N1=N1+mod(N1,2);                       % 保证滤波器阶数为偶数
b=fir2(N1,f,a);                        % 用fir2函数求出滤波器系数
[db1,mag1,pha1,grd1,w1]=freqz_m(b,1);  % 求出滤波器频域响应
% 等波纹法
A=[0 1 0 1 0 1];                       % 构成幅值矢量
devp=(10^(rp/20)-1)/(10^(rp/20)+1);    % 求出通带的偏差值
devs=10^(-as/20);                      % 求出阻带的偏差值
dev=[devs devp devs devp devs devp];   % 构成滤波器设计中的偏差矢量
[N2,F0,A0,W]=firpmord(Fc,A,dev);       % 用firpmord求出滤波器的阶数
N2=N2+mod(N2,2);                       % 保证滤波器阶数为偶数
df=Fs2/500;                            % 频域分辨率
ns1=ceil(fc1/df)+1;                    % fc1对应的样点值
wlis=1:ns1;                            % 阻带样点区间
Acs=1;                                 % Acs初始值
while Acs>-as                          % 阻带衰减不满足条件将循环
    h=firpm(N2,F0,A0,W);               % 用firpm函数设计滤波器
    [db2, mag2, pha2, grd2,w2]=freqz_m(h,1);  % 计算滤波器频域响应
    Acs=max(db2(wlis));                % 求阻带衰减值
    fprintf('N=%4d   As=%5.2f\n',N2,-Acs); % 显示滤波器阶数和衰减值
    N2=N2+2;                           % 阶数加2,保证为第1类滤波器
end
N2=N2-2;                               % 修正N2值
% 作图
subplot 211; plot(w1/pi*Fs2,db1,'k','linewidth',2)
grid; axis([0 1000 -80 10]);
set(gca,'XTickMode','manual','XTick',[0 220 260 340 380 520 560 640 680 820 860 1000])
set(gca,'YTickMode','manual','YTick',[-40,0])
title('(a)fir2函数设计滤波器幅值响应'); 
xlabel('频率/kHz'); ylabel('幅值/dB')
subplot 212; plot(w2/pi*Fs2,db2,'k','linewidth',2)
grid; axis([0 1000 -80 10]);
set(gca,'XTickMode','manual','XTick',[0 220 260 340 380 520 560 640 680 820 860 1000])
set(gca,'YTickMode','manual','YTick',[-40,0])
title('(b)等波纹法设计滤波器幅值响应'); 
xlabel('频率/kHz'); ylabel('幅值/dB')
set(gcf,'color','w');




