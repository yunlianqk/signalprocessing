%
% pr3_5_1 
clear all; clc; close all;

fs=5000;                       % 采样频率
N=500;                         % 样点数
n=1:N;
t1=(n-1)/fs;                   % 设置时间
x1=sin(2*pi*50*t1);            % 产生笫1个正弦信号
x2=(1/3)*sin(2*pi*150*t1);     % 产生笫2个正弦信号
z=x1+x2;                       % 把两个信号叠加
imp=emd(z);                    % 对叠加信号进行EMD分解
[m,n]=size(imp);               % 求取EMD分解成几个分量
% 作图
subplot(m+1,1,1);              % 画叠加信号
plot(t1,z,'k');title('原始信号'); ylabel('幅值')
subplot 312;                   % 画第1个正弦信号
line(t1,x2,'color',[.6 .6 .6],'linewidth',5); hold on
subplot 313;                   % 画第2个正弦信号
line(t1,x1,'color',[.6 .6 .6],'linewidth',5); hold on
for i=1:m
    subplot(m+1,1,i+1);        % 画EMD分解后的信号
    plot(t1,imp(i,:),'k','linewidth',1.5); ylabel('幅值')
    title(['imf' num2str(i)]);
end
xlabel('时间/s');

