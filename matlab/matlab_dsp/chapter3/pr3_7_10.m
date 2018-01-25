% 
% pr3_7_10 
clear all; clc; close all;

fs=1600;                             % 采样频率
f0=50;                               % 基波频率
N=400;                               % 数据长度
t=(0:N-1)/fs;                        % 时间刻度
x=zeros(1,N);                        % x初始化
for k=1 : 2 : 10                     % 产生信号
    x=x+(10/pi/k)*sin(2*pi*k*f0*t);  
end

fs2=fs/2;                            % 奈奎斯特频率
wp=[40 60]/fs2; ws=[30 80]/fs2;      % 通带和阻带
Rp=1; Rs=40;                         % 通带波纹和阻带衰减
[M,Wn]=ellipord(wp,ws,Rp,Rs);        % 求原型滤波器阶数和带宽
[B,A]=ellip(M,Rp,Rs,Wn);             % 求数字滤波器系数

[b0,b,a]=dir2cas(B,A);               % 把滤波器系数分解为串级子系统的系数
fprintf('B1=%5.6f   %5.6f   %5.6f\n',b(1,:));
fprintf('A1=%5.6f   %5.6f   %5.6f\n',a(1,:));
fprintf('\n');
fprintf('B2=%5.6f   %5.6f   %5.6f\n',b(2,:));
fprintf('A2=%5.6f   %5.6f   %5.6f\n',a(2,:));
fprintf('\n');
fprintf('B3=%5.6f   %5.6f   %5.6f\n',b(3,:));
fprintf('A3=%5.6f   %5.6f   %5.6f\n',a(3,:));
fprintf('\n');
% 方法一
yy=casfiltr(b0,b,a,x);               % 方法一:用casfiltr函数对输入信号滤波
% 方法二
u(1)=0; u(2)=0;                      % 初始化
v(1)=0; v(2)=0;
y(1)=0; y(2)=0;
xx(1)=0; xx(2)=0;
% 方法二:用子系统的差分方程对输入信号滤波
for k=3 : N+2
    j=k-2;
    xx(k)=x(j);
    u(k)=b(1,1)*xx(k)+b(1,2)*xx(k-1)+b(1,3)*xx(k-2)-a(1,2)*u(k-1)-a(1,3)*u(k-2);
    v(k)=b(2,1)*u(k)+b(2,2)*u(k-1)+b(2,3)*u(k-2)-a(2,2)*v(k-1)-a(2,3)*v(k-2);
    y(k)=b(3,1)*v(k)+b(3,2)*v(k-1)+b(3,3)*v(k-2)-a(3,2)*y(k-1)-a(3,3)*y(k-2);
end
y=b0*y(3:end);                       % 输出信号y
% 作图
subplot 211; plot(t,x,'k');
title('输入信号波形');
xlabel('时间/s'); ylabel('幅值');
subplot 212; line(t,yy,'color',[.6 .6 .6],'linewidth',3); hold on
plot(t,y,'k');
title('输出信号波形');
legend('1','2',2)
xlabel('时间/s'); ylabel('幅值'); box on;
set(gcf,'color','w');

