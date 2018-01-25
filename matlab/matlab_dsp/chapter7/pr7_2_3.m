%
% pr7_2_3  
clc; clear all; close all;

f0=49.13;                    % 基波频率
fs=3200;                     % 采样频率
N=2048;                      % 数据长度
n=0:N-1;                     % 数据索引
rad=pi/180;                  % 角度和弧度的转换因子
xb=[240,0.1,12,0.1,2.7,0.05,2.1,0,0.3,0,0.6]; % 谐波幅值
Q=[0,10,20,30,40,50,60,0,80,0,100]*rad;       % 谐波初始相位
s=zeros(1,N);                % 初始化
M=11;                        % 谐波个数
for i=1:M                    % 产生谐波信号
    s=s+xb(i)*cos(2*pi*f0*i*n./fs+Q(i));
end
% Blackman-Harris窗
w=0.35875-0.48829*cos(2*pi*n/N)+0.14128*cos(4*pi*n/N)-0.01168*cos(6*pi*n/N);
x=s.*w;                      % 信号乘以窗函数
v=fft(x,N);                  % FFT
u=abs(v);                    % 取频谱的幅值
k1=zeros(1,M);               % 初始化
k2=zeros(1,M);
A=zeros(1,M);
ff=zeros(1,M);
Ph=zeros(1,M);
df=fs/N;                     % 频率分瓣率

for i=1:M                    % 计算基波和各阶谐波的参数
    if i==1                  % 若计算基波,在40-60Hz区间中寻找最大峰值
        n1=fix(40/df); n2=fix(60/df); % 求出40Hz和60Hz对应的索引号
    else                     % 若计算谐波,从该谐波理论值-10和+10的区间中寻找最大值
        n1=fix((i*ff(1)-20)/df);      % 求出区间对应的索引号
        n2=fix((i*ff(1)+20)/df);
    end
    [um,ul]=max(u(n1:n2));   % 在区间中找出最大值
    k1(i)=ul+n1-1;           % 给出最大值的索引号
% 判断峰值在最大值左边还是右边,如果峰值在最大值左边,把k1(i)进行修正    
    if u(k1(i)-1)>u(k1(i)+1), k1(i)=k1(i)-1; end
    k2(i)=k1(i)+1;           % 求出k2(i),使峰值永远在k1(i)和k2(i)之间
    y1=u(k1(i));             % 求出y1和y2
    y2=u(k2(i));
    b=y2/y1;                 % 按式(7-2-5)计算出beta
% Blackman-Harris窗的beta对alpha的表示式
    a=-2.349139+6.314136*b-7.223542*b^2+6.708777*b^3-4.44887*b^4+...
        1.934912*b^5-0.491347*b^6+0.055074*b^7;   
% 按alpha的数值决定最大值的索引号和gamma值
    if (a>=0) & (a<=0.5)     % 若k1是最大值索引
        yk=y1;
        gama=a;
    elseif (a>0.5) & (a<=1)  % 若k2是最大值索引
        yk=y2;
        gama=-(1-a);
    end
% 按式(7-2-9)依Blackman-Harris窗的窗函数关系计算出谐波的幅值
    A(i)=yk*(5.574913+2.111148*(gama)^2+0.43251*(gama)^4+0.067945*(gama)^6)/N; 
    ff(i)=(k1(i)-1+a)*fs/N;       % 求出谐波的频率 
    Ph(i)=phase(v(k1(i)))-pi*a;   % 求出谐波的初始相位 
    Ph(i)=Ph(i)-(Ph(i)>pi)*2*pi+(Ph(i)<-pi)*2*pi; % 对相位进行修正
% 若幅值过小设为0,并对频率相位修正
    if A(i)<0.0005, A(i)=0; ff(i)=i*ff(1); Ph(i)=0; end 
% 显示谐波参数
    fprintf('%4d   %5.6f   %5.6f   %5.6f\n',i,A(i),ff(i),Ph(i)/rad);
end  

