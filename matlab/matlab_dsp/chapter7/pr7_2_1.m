% pr7_2_1  
% 海宁窗
clear all; clc; close all;

N=1024;                      % 窗函数长
n=0:N-1;                     % 索引号
w=0.5-0.5*cos(2*pi*n/N);     % 窗函数
alpha=0:0.01:1;              % 设置alpha矢量
M=length(alpha);             % alpha的长度
for k=1 : M                  % 计算beta和alpha的关系
    al=alpha(k);             % 取一个alpha值
    dk1=-al;                 % 给出-alpha
    dk2=1-al;                % 给出1-alpha
    W1=dtft_dkm(w,dk1,0);    % 计算式(7-2-13)的分母
    W2=dtft_dkm(w,dk2,0);    % 计算式(7-2-13)的分子
    beta(k)=abs(W2)/abs(W1); % 求出beta值
end
a=polyfit(beta,alpha,7);     % 计算beta对alpha的拟合多项式系数
y=polyval(a,beta);           % 计算beta对alpha的拟合曲线
% 作图和显示beta对alpha拟合多项式系数
subplot 211; plot(beta,alpha,'k'); hold on
plot(beta,y,'r'); grid
xlabel('\beta'); ylabel('\alpha');
title('\alpha=g^-^1(\beta)')
fprintf('%5.6f   %5.6f   %5.6f   %5.6f\n',a)
fprintf('\n');

gamma=-0.5:0.01:0.5;         % 设置gamma矢量
M=length(gamma);             % gamma长度
for k=1 : M                  % 计算gamma和Ap的关系
    al=gamma(k);             % 取一个gamma值
    dk1=-al;                 % 给出-gamma
    W1=dtft_dkm(w,dk1,0);    % 计算式(7-2-14)的分母
    Ap(k)=2*N/abs(W1);       % 求出Ap值
end
a=polyfit(gamma,Ap,6);       % 计算gamma对Ap的拟合多项式系数
y=polyval(a,gamma);          % 计算gamma对Ap的拟合曲线
% 作图和显示gamma对Ap拟合多项式系数
subplot 212; plot(gamma,Ap,'k'); grid;
plot(gamma,y,'r'); grid
xlabel('\gamma'); ylabel('Ap'); 
title('Ap=\lambda(\gamma)')
fprintf('%5.6f   %5.6f   %5.6f   %5.6f\n',a)
fprintf('\n');
set(gcf,'color','w'); 