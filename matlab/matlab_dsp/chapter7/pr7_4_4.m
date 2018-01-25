%
% pr7_4_4  
close all; clear all; clc

load damp_data2.mat          % 读入数据
plot(ti,x,'g');              % 画出数据x曲线
grid; hold on 
L=length(x);                 % 数据长度
x0=mean(x(L-50:L));          % 求出指数衰减终值
u=x-x0;                      % 消除直流分量
plot(ti,u,'r','linewidth',2); % 画出数据u曲线
title('信号数据曲线图');
xlabel('时间/s'); ylabel('电压/pu');
p=30;                        % 设置阶次
Z=signal_hpronys(u,p,fs,.01);% Prony法提取参数
K=size(Z,1);                 % K中为多少个分量

y=zeros(1,L);                % 初始化
for k=1 : K                  % 显示K个信号分量的参数
   fprintf('%4d     D=%5.6f   F=%5.6f  A=%6.5f  theta=%6.5f\n',...
       k,Z(k,1),Z(k,2),Z(k,3),Z(k,4));
% 把K个分量重构成信号y
   y=y+Z(k,3)*exp(Z(k,1)*ti).*cos(2*pi*Z(k,2)*ti+Z(k,4));
end
plot(ti,y,'k');              % 画出重构信号y的曲线
legend('信号消除直流分量前','信号消除直流分量后','重构信号');
snr=prony_snr(u,y);          % 计算u与y的信噪比
fprintf('SNR=%5.6f\n',snr);  % 显示信噪比
set(gcf,'color','w');
