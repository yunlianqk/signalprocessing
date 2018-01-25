function y=myditfft(x)
%《数字信号处理教程——MATLAB释义与实现》
% 用MATLAB语言编写的基2 DIT FFT子程序
% 电子工业出版社出版  陈怀琛编著 2004年9月
%
% y=myditfft(x)
% ------------------------------------------------------------
% 本程序对输入序列 x 实现DIT-FFT基2算法，点数取大于等于x长度的2的幂次
% x为给定时间序列
% y为x的离散傅立叶变换
% 
m=nextpow2(x);N=2^m;            % 求x的长度对应的2的最低幂次m
if length(x)<N 
    x=[x,zeros(1,N-length(x))]; % 若x的长度不是2的幂，补零到2的整数幂
end  
nxd=bin2dec(fliplr(dec2bin([1:N]-1,m)))+1;   % 求1:2^m数列的倒序
y=x(nxd);                             % 将x倒序排列作为y的初始值
for mm=1:m             % 将DFT作m次基2分解,从左到右，对每次分解作DFT运算
Nmr=2^mm;u=1;           % 旋转因子u初始化为WN^0=1
WN=exp(-i*2*pi/Nmr);    % 本次分解的基本DFT因子WN=exp(-i*2*pi/Nmr)
  for j=1:Nmr/2         % 本次跨越间隔内的各次蝶形运算
    for k=j:Nmr:N       % 本次蝶形运算的跨越间隔为Nmr=2^mm
      kp=k+Nmr/2;        % 确定蝶形运算的对应单元下标
      t=y(kp)*u;        % 蝶形运算的乘积项
      y(kp)=y(k)-t;     % 蝶形运算
      y(k)=y(k)+t;      % 蝶形运算
    end
  u=u*WN;               % 修改旋转因子,多乘一个基本DFT因子WN
  end
end
