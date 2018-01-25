% 
% pr7_3_4 
clear all; clc; close all;

f0=49.13;                    % 基波频率
fs=3200;                     % 采样频率
N=2048;                      % 数据长度
n=0:N-1;                     % 数据索引
rad=pi/180;                  % 角度和弧度的转换因子
xb=[240,0.1,12,0.1,2.7,0.05,2.1,0,0.3,0,0.6]; % 谐波幅值
Q=[0,10,20,30,40,50,60,0,80,0,100]*rad;       % 谐波初始相位

M=11;                        % 谐波个数
df=fs/N;                     % 频率分瓣率
t=n/fs;                      % 时间序列
%4项3阶的Nuttall窗函数
win=0.338946-0.481973*cos(2*pi*n/N)+0.161054*cos(4*pi*n/N)-0.018027*cos(6*pi*n/N);
x=zeros(1,N);                % 初始化
for k=1 : M                  % 产生谐波信号
x=x+xb(k)*cos(2*pi*f0*k*t+Q(k));
end
X=fft(x.*win);               % 信号乘以窗函数和FFT
Y=abs(X);                    % 取频谱的幅值
A=zeros(1,M);                % 初始化
ff=zeros(1,M);
Ph=zeros(1,M);

for k=1 : M                  % 计算基波和各阶谐波的参数
    if k==1                  % 若计算基波,在40-60Hz区间中寻找最大峰值
        n1=fix(40/df); n2=fix(60/df); % 求出40Hz和60Hz对应的索引号
    else                     % 若计算谐波,从该谐波理论值-10和+10的区间中寻找最大值
        n1=fix((k*ff(1)-10)/df); % 求出区间对应的索引号
        n2=fix((k*ff(1)+10)/df);
    end
    [Fm,nn]=max(Y(n1:n2));   % 在区间中找出最大值
    nm=nn+n1-1;              % 给出最大值的索引号
    if Y(nm+1)==Y(nm-1)
        delta=0;
    elseif Y(nm+1)<Y(nm-1);
        nm=nm-1;
    end
    y1=Y(nm);                % 求出y1和y2
    y2=Y(nm+1);
    beta=(y2-y1)/(y2+y1);    % 按式(7-3-3)计算出beta
% 4项3阶的Nuttall窗的beta对alpha的表示式
    alpha=2.954945*beta+0.176716*beta^3+0.092435*beta^5;
% 按式(7-3-9)依4项3阶的Nuttall窗的窗函数关系计算出谐波的幅值
    A(k)=(y1+y2)*(3.209756+0.91918*alpha^2+0.141894*alpha^4+...
       0.016482*alpha^6)/N;
    ff(k)=(nm-1+alpha+0.5)*fs/N;         % 求出谐波的频率
    Ph(k)=angle(X(nm))-pi*(alpha+0.5);   % 求出谐波的初始相位
    Ph(k)=Ph(k)-(Ph(k)>pi)*2*pi+(Ph(k)<-pi)*2*pi; % 对相位进行修正
% 若幅值过小设为0,并对频率相位修正
    if A(k)<0.0005, A(k)=0; ff(k)=k*ff(1); Ph(k)=0; end    
% 显示谐波参数
    fprintf('%4d      %5.6f  %5.6f  %5.6f\n',k,ff(k),A(k),Ph(k)/rad);
end

