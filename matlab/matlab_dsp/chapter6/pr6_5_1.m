%
% pr6_5_1  
close all;clc;clear all;

fs = 2000;                             % 采样频率
N  = 1024;                             % FFT长
arc=pi/180;                            % 1弧度
n=-N+1:2*N-1;                          % 数据索引的设置               
t2=n/fs;                               % 时间刻度

Am=[1 0.8 0.6 0.4 0.2];                % 幅值参数 
Fr=[49.1 149.2 249.3 349.4 449.5];     % 频率参数(Hz)
Theta=[50 100 150 200 250];            % 初始相位参数(度)

x=zeros(1,3*N-1);                      % 数据初始化
% 产生信号
for k=1 : 5
    x=x+Am(k)*cos(2*pi*Fr(k)*t2+Theta(k)*arc);  % 构成信号
end
% 每个分量寻找频率的区间
NX=[45, 55; 145, 155; 245, 255; 345, 355; 445, 455];
L=N; M=N;

y=x(N:end);                            % 为传统FFT相位差法校正准备数据
EZ=zeros(3,5,3);                       % 对偏差值数组初始化
for k=1 : 5                            % 计算5个正弦分量的参数并显示
    fprintf('%1d通道理论值   幅值=%5.2f    频率=%5.2f   初始相位=%5.2f\n',...
        k,Am(k),Fr(k),Theta(k));
    Z=apFFTcorrm(x,N,L,fs,NX(k,1),NX(k,2));              % 方法1校正
    EZ(1,k,:)=[Am(k)-Z(1) Fr(k)-Z(2) Theta(k)-Z(3)/arc]; % 计算偏差值
    fprintf('方法1  %5.6f  %5.6f   %5.6f\n',Z(1),Z(2),Z(3)/arc);
    Z=FFT_apFFTcorrm(x,N,fs,NX(k,1),NX(k,2));            % 方法2校正
    fprintf('方法2  %5.6f  %5.6f   %5.6f\n',Z(1),Z(2),Z(3)/arc);
    EZ(2,k,:)=[Am(k)-Z(1) Fr(k)-Z(2) Theta(k)-Z(3)/arc]; % 计算偏差值
    Z=Phase_Gmtda(y,N,L,M,fs,NX(k,1),NX(k,2),2);         % 方法3校正
    if Z(3)<0, Z(3)=2*pi+Z(3); end                       % 使相角在0~2*pi之间
    fprintf('方法3  %5.6f  %5.6f   %5.6f\n',Z(1),Z(2),Z(3)/arc);
    EZ(3,k,:)=[Am(k)-Z(1) Fr(k)-Z(2) Theta(k)-Z(3)/arc]; % 计算偏差值
    fprintf('\n');
       
end
% 显示计算5个正弦分量的参数和理论值的偏差
for k=1 : 5
    fprintf('%1d通道\n',k);
    fprintf('方法1   %5.6e  %5.6e   %5.6e\n',EZ(1,k,1),EZ(1,k,2),EZ(1,k,3));
    fprintf('方法2   %5.6e  %5.6e   %5.6e\n',EZ(2,k,1),EZ(2,k,2),EZ(2,k,3));
    fprintf('方法3   %5.6e  %5.6e   %5.6e\n',EZ(3,k,1),EZ(3,k,2),EZ(3,k,3));
    fprintf('\n');
end




