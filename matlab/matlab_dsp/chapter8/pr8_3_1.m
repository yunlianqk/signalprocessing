%
% pr8_3_1 
clear all; clc; close all;

r1=0.98; r2=0.98;                      % 极点的半径
theta1=0.2*pi; theta2=0.3*pi;          % 极点的相角
% 计算滤波器传递函数的分母部分
A=conv([1 -2*cos(0.2*pi)*0.98 0.98*0.98],[1 -2*cos(0.3*pi)*0.98 0.98*0.98]);
B=1;                                   % 滤波器传递函数的分子部分
P = 4;                                 % 阶数      
N = 256;                               % x(n)长度
M=1024;                                % FFT变换长度
M2=M/2+1;                              % 正频率长度
% PSD理论值
S1 = 20*log10(abs(freqz(B, A, M2)))-10*log10(P);

f = (0 : M2-1)/M2;                     % 频率刻度            
E_yu=zeros(M2,1);                      % 初始化
E_bg=zeros(M2,1);
E_cv=zeros(M2,1);
E_mv=zeros(M2,1);
L=200;                                 % 用随机数循环次数
for k=1 : L                            % 进行L次循环
    w = randn(N,1);                    % 产生随机数
    x = filter(B, A, w);               % 通过B/A构成的滤波器
    px1=pyulear(x,4,M);                % 用Yule-Walker法计算功率谱
    px2=pburg(x,4,M);                  % 用Burg法计算功率谱
    px3=pcov(x,4,M);                   % 用协方差法计算功率谱
    px4=pmcov(x,4,M);                  % 用改进协方差法计算功率谱
    S_yule = 10*log10(px1);            % 取对数
    S_burg = 10*log10(px2);
    S_cov = 10*log10(px3);
    S_mcov = 10*log10(px4);
    E_yu=E_yu+S_yule;                  % 累加
    E_bg=E_bg+S_burg;
    E_cv=E_cv+S_cov;
    E_mv=E_mv+S_mcov;
end
E_yu=E_yu/L;                           % 求取平均值
E_bg=E_bg/L;
E_cv=E_cv/L;
E_mv=E_mv/L;
% 作图
subplot 221; plot(f,S1,'k',f,E_yu,'r');
legend('True PSD', 'pyulear',3);
title('Yule-Walker法')
ylabel('幅值(dB)'); grid; xlim([0 0.5]);
subplot 222; plot(f,S1,'k',f,E_bg,'r');
legend('True PSD', 'pburg',3);
title('Burg法')
ylabel('幅值(dB)'); grid; xlim([0 0.5]);
subplot 223; plot(f,S1,'k',f,E_cv,'r');
legend('True PSD', 'pcov',3);
title('Cov法')
xlabel('归一化频率'); ylabel('幅值(dB)');grid; xlim([0 0.5]);
subplot 224; plot(f,S1,'k',f,E_mv,'r');
legend('True PSD', 'pmcov',3);
title('Mcov法')
xlabel('归一化频率'); ylabel('幅值(dB)');grid; xlim([0 0.5]);
set(gcf,'color','w'); 

