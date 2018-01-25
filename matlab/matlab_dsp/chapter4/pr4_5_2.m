%
% pr4_5_2 from sy12
clear all; clc; close all;

k=1:500;                    % 产生一个从0到2*pi的向量，长为500               
dn=2*pi/500;
x=cos((k-1)*dn);            % 产生一个周期余弦信号
[val,loc]=min(x);           % 求出余弦信号中的最小值幅值和位置
N=length(x);                % 数据长
ns=randn(1,N);              % 产生随机信号
y=x+ns(1:N)*0.1;            % 构成带噪信号
Err=var(x-y);               % 求x-y的方差
fprintf('%4d   %5.4f   %5.6f\n',loc,val,Err);

y=y';                       % 转成列向量
z1=smooth(y,51,'moving');   % 'moving'平滑
Err1=var(x'-z1);            % 求x-z1的方差 
[v1,k1]=min(z1);            % 求出平滑信号z1中的最小值幅值和位置
fprintf('1  %4d   %5.4f   %4d   %5.6f\n',k1,v1,abs(loc-k1),Err1);  % 显示

z2=smooth(y,51,'lowess');   % 'lowess'平滑
Err2=var(x'-z2);            % 求x-z2的方差
[v2,k2]=min(z2);            % 求出平滑信号z2中的最小值幅值和位置
fprintf('2  %4d   %5.4f   %4d   %5.6f\n',k2,v2,abs(loc-k2),Err2);

z3=smooth(y,51,'loess');    % 'loess'平滑
Err3=var(x'-z3);            % 求x-z3的方差
[v3,k3]=min(z3);            % 求出平滑信号z3中的最小值幅值和位置
fprintf('3  %4d   %5.4f   %4d   %5.6f\n',k3,v3,abs(loc-k3),Err3);

z4=smooth(y,51,'sgolay',3); % 'sgolay'平滑
Err4=var(x'-z4);            % 求x-z4的方差
[v4,k4]=min(z4);            % 求出平滑信号z4中的最小值幅值和位置
fprintf('4  %4d   %5.4f   %4d   %5.6f\n',k4,v4,abs(loc-k4),Err4);

z5=smooth(y,51,'rlowess');  % 'rlowess'平滑
Err5=var(x'-z5);            % 求x-z5的方差
[v5,k5]=min(z5);            % 求出平滑信号z5中的最小值幅值和位置
fprintf('5  %4d   %5.4f   %4d   %5.6f\n',k5,v5,abs(loc-k5),Err5);

z6=smooth(y,51,'rloess');   % 'rloess'平滑
Err6=var(x'-z6);            % 求x-z6的方差
[v6,k6]=min(z6);            % 求出平滑信号z6中的最小值幅值和位置
fprintf('6  %4d   %5.4f   %4d   %5.6f\n',k6,v6,abs(loc-k6),Err6);
% 作图
subplot 211; plot(k,x,'k');
grid; xlim([0 500]); title('一周期余弦信号')
xlabel('样点'); ylabel('幅值')
subplot 212; plot(k,y,'k'); %hold on
grid; axis([0 500 -1.5 1.5]); title('带噪一周期余弦信号')
xlabel('样点'); ylabel('幅值')
set(gcf,'color','w');

figure
subplot 321; plot(k,z1,'k'); title('moving法')
grid; axis([0 500 -1.5 1.5]); ylabel('幅值')
subplot 322; plot(k,z2,'k');  title('lowess法')
grid; axis([0 500 -1.5 1.5]); ylabel('幅值')
subplot 323; plot(k,z3,'k'); title('loess法')
grid; axis([0 500 -1.5 1.5]); ylabel('幅值')
subplot 324; plot(k,z4,'k'); title('sgolay法')
grid; axis([0 500 -1.5 1.5]); ylabel('幅值')
subplot 325; plot(k,z5,'k'); title('rlowess法')
grid; axis([0 500 -1.5 1.5]); xlabel('样点'); ylabel('幅值')
subplot 326; plot(k,z6,'k'); title('rloess法')
grid; axis([0 500 -1.5 1.5]); xlabel('样点'); ylabel('幅值')
set(gcf,'color','w');


