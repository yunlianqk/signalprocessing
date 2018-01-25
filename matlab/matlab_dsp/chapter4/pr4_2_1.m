%
% pr4_2_1 
clear all; clc; close all;

y=load('ffpulse.txt');       % 读入脉搏数据
x=detrend(y);                % 消除趋势项
fs=200;                      % 采样频率
N=length(x);                 % 数据长度
time=(0:N-1)/fs;             % 时间刻度
% 第一部分,用findpeaks函数求峰值位置
[Val,Locs]=findpeaks(x,'MINPEAKHEIGHT',200,'MINPEAKDISTANCE',100);
T1=time(Locs);               % 取得脉搏峰值时间
M1=length(T1);
T11=T1(2:M1);
T12=T1(1:M1-1);
Mdt1=mean(T11-T12);          % 从峰值得的平均周期值
fprintf('峰值求得的平均周期值=%5.4f\n',Mdt1);
% 作图
pos = get(gcf,'Position');
set(gcf,'Position',[pos(1), pos(2)-100,pos(3),(pos(4)-140)]);
plot(time,x,'k'); hold on; grid;
plot(time(Locs),Val,'ro','linewidth',3);
xlabel('时间/s'); ylabel('幅值'); title('脉搏信号波形图')
set(gcf,'color','w');
pause
% 第二部分,用findpeakm函数求谷值位置
[K,V]=findpeakm(x,'v',100);
T2=time(K);                  % 取得脉搏谷值时间
M2=length(T2);
T21=T2(2:M1);
T22=T2(1:M1-1);
Mdt2=mean(T21-T22);          % 从谷值得的平均周期值
fprintf('谷值求得的平均周期值=%5.4f\n',Mdt2);
% 作图
plot(time(K),V,'gO','linewidth',3);
set(gcf,'color','w');

