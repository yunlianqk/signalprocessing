%
% pr4_4_1 
clear all; clc; close all;

x=load('lg1.txt');                   % 读入数据
N=length(x);                         % 数据长度
n=1:N;                               % 样点索引号
dx=diff(x);                          % 求一阶导数
Xdex=find(dx<0);                     % 寻找一阶导数为负值
Xseg=findSegment(Xdex);              % 寻找一阶导数为负值的区间
Xsel=length(Xseg);                   % 导数为负值区间的个数
for k=1 :Xsel                        % 显示导数为负值区间的起始,结束和长度
    fprintf('%4d   %4d   %4d   %4d\n',k,Xseg(k).begin,...
        Xseg(k).end,Xseg(k).duration);
    X_begin(k)=Xseg(k).begin;        % 设置导数为负值区间起始位置的数组
    X_duration(k)=Xseg(k).duration;  % 设置导数为负值区间长度的数组
end
Xpdex=find(dx>0);                     % 寻找一阶导数为正值
Xpseg=findSegment(Xpdex);             % 寻找一阶导数为正值的区间
Xpsel=length(Xpseg);                  % 导数为正值区间的个数
for k=1 :Xpsel                        % 显示导数为正值区间的起始,结束和长度
    fprintf('%4d   %4d   %4d   %4d\n',k,Xpseg(k).begin,...
        Xpseg(k).end,Xpseg(k).duration);
    Xp_begin(k)=Xpseg(k).begin;       % 设置导数为正值区间起始位置的数组
    Xp_duration(k)=Xpseg(k).duration; % 设置导数为正值区间长度的数组
end
% 处理一阶导数为负值的情况下,寻找第1波谷的开始位置
pnb=find(X_begin>10);                % 寻找区间起始位置要大于10
pn=find(X_duration(pnb)>2);          % 寻找区间长度要大于2
kk=pnb(pn);                          % 求得满足条件区间起始位置              
Stpn=Xseg(kk(1)).begin;              % 求得第1个波谷的开始位置
% 处理一阶导数为正值的情况下,寻找第1波谷的结束位置
ppnb=find(Xp_begin>Stpn);            % 寻找区间起始位置要大于Stpn的开始位置
ppn=find(Xp_duration(ppnb)>2);       % 寻找区间长度要大于2
kk1=ppnb(ppn);                       % 求得满足条件区间结束位置  
Edpn=Xpseg(kk1(1)).end;              % 求得第1个波谷的结束位置
% 作图
subplot 211; plot(n,x,'k')
hold on; axis([0 N 3200 3800]); grid
xlabel('样点'); ylabel('幅值')
title('信号波形')
subplot 212; plot(n,[0 dx],'k'); grid; xlim([0 N]);
xlabel('样点'); ylabel('一阶导数值')
title('一阶导数曲线')
subplot 211; plot(Stpn,x(Stpn),'rO','linewidth',5);
plot(Edpn,x(Edpn),'gO','linewidth',5);
fprintf('开始位置=%4d    结束位置=%4d\n',Stpn,Edpn);
set(gcf,'color','w');



