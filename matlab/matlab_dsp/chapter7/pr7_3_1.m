%
% pr7_3_1 
clear all; clc; close all;

N=1024;                      % 窗函数长
n=0:N-1;                     % 索引号
w=0.5-0.5*cos(2*pi*n/N);     % 窗函数
alpha=-0.5:0.01:0.5;         % 设置alpha矢量
M=length(alpha);             % alpha的长度
for k=1 : M                  % 计算beta和alpha的关系计算alpha和nu的关系
    al=alpha(k);             % 取一个alpha值
    dk1=-al+0.5;             % 给出-alpha+0.5
    dk2=-al-0.5;             % 给出-alpha-0.5
    W1=dtft_dkm(w,dk1,0);    % 计算式(7-3-3)的分子第1项
    W2=dtft_dkm(w,dk2,0);    % 计算式(7-3-3)的分子第2项
    beta(k)=(abs(W1)-abs(W2))/(abs(W1)+abs(W2)); % 求出beta值
    nu(k)=2*N/(abs(W1)+abs(W2));              % 求出nu值 
end
a=polyfit(beta,alpha,6);     % 计算beta对alpha的拟合多项式系数
y=polyval(a,beta);           % 计算beta对alpha的拟合曲线
% 作图和显示beta对alpha拟合多项式系数
subplot 211; plot(beta,alpha,'k'); hold on
plot(beta,y,'r'); grid
xlabel('\beta'); ylabel('\alpha');
title('\alpha=g^-^1(\beta)')
fprintf('%5.6f   %5.6f   %5.6f   %5.6f\n',a)
fprintf('\n');
subplot 212; plot(alpha,nu,'k'); hold on
a=polyfit(alpha,nu,6);       % 计算alpha对nu的拟合多项式系数
y=polyval(a,alpha);          % 计算alpha对nu的拟合曲线
% 作图和显示alpha对nu拟合多项式系数
subplot 212; plot(alpha,nu,'k'); hold on
plot(alpha,y,'r'); grid
xlabel('\alpha'); ylabel('\nu');
title('\nu(\alpha)')
fprintf('%5.6f   %5.6f   %5.6f   %5.6f\n',a);
fprintf('\n');


