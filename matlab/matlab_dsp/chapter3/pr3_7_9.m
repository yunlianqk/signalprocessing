% 
% pr3_7_9 
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
[H,f]=freqz(B,A,1000,fs);            % 滤波器响应曲线
gdy=grpdelay(B,A,1000,fs);           % 群延迟响应曲线
% 显示数字滤波器系数
fprintf('B=%5.6e   %5.6e   %5.6e   %5.6e\n',B);
fprintf('\n');
fprintf('A=%5.6f   %5.6f   %5.6f   %5.6f\n',A);
fprintf('\n');
% 方法一
yy=filter(B,A,x);                    % 方法一:用filter函数对输入信号滤波
% 方法二
for k=1 : 6                          % 初始化
    xx(k)=0; y(k)=0;
end

for k=7 : N+6                        % 方法二:用差分方程对输入信号滤波
    j=k-6;
    xx(k)=x(j);
    y(k)=B(1)*xx(k)+B(2)*xx(k-1)+B(3)*xx(k-2)+B(4)*xx(k-3)+B(5)*xx(k-4)...
        +B(6)*xx(k-5)+B(7)*xx(k-6)-A(2)*y(k-1)-A(3)*y(k-2)-A(4)*y(k-3)...
        -A(5)*y(k-4)-A(6)*y(k-5)-A(7)*y(k-6);
end
y=y(7:end);                          % 输出信号y
% 作图
figure(1)
subplot 211; plot(f,20*log10(abs(H)),'k');
title('椭圆带通滤波器幅频响应曲线')
xlabel('频率/Hz'); ylabel('幅值/dB');
axis([0 100 -60 5]); grid;
subplot 212; plot(f,gdy,'k');
title('椭圆带通滤波器群延迟响应曲线')
xlabel('频率/Hz'); ylabel('群延迟/样点'); 
xlim([0 100]); grid
set(gcf,'color','w');
figure(2)
subplot 211; plot(t,x,'k');
title('输入信号波形');
xlabel('时间/s'); ylabel('幅值');
subplot 212; line(t,yy,'color',[.6 .6 .6],'linewidth',3); hold on
plot(t,y,'k');
title('输出信号波形');
legend('1','2',2)
xlabel('时间/s'); ylabel('幅值'); box on;
set(gcf,'color','w');

