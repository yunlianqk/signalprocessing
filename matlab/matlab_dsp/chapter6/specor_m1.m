function Z=specor_m1(x,fs,N,NX,method)
if nargin<3, N=length(x); NX=[0 fs/2]; method=1; end % 参数不足时的设置
if nargin<4, NX=[0 fs/2]; method=1; end
if nargin<5, method=1; end
if method<1 | method>2           % method小于1或大于2,都设为method=1
    disp('method-value should be equal to 1 or 2');
    method=1;
end
x=x(:)';                         % 设置x为行序列
w=hann(N,'periodic');            % 求出海宁窗函数
if method==2                     % 若调用时用海宁窗函数
    xf=fft(x.*w');               % 信号加窗后FFT
    xf=xf(1:N/2)/N*4;            % 把信号的幅值修正
    WindowType=2;                % 设WindowType=2;
else
    xf=fft(x);                   % FFT
    xf=xf(1:N/2)/N*2;            % 把信号的幅值修正
    WindowType=1;                % 设WindowType=1;
end
ddf=fs/N;                        % 求出频率分辨率
nx1=NX(1); nx2=NX(2);            % 给出求最大值频率的区间
n1=fix(nx1/ddf);                 % 按频率区间给出索引号
n2=round(nx2/ddf);

A=abs(xf);                       % 求取模值
[Amax,index]=max(A(n1:n2));      % 从索引号取间求出最大值
index=index+n1-1;                % 给出最大值的索引号
phmax=angle(xf(index));          % 求出相角未修正时的数值
    
%比值法_加矩形窗
if (WindowType==1)               % 若是矩形窗
    indsecL=A(index-1)>A(index+1);  % 给出X(k-1)>X(k+1)的逻辑量
    % 按式(6-2-5)计算Δk
    df=indsecL.*A(index-1)./(Amax+A(index-1))-...
        (1-indsecL).*A(index+1)./(Amax+A(index+1));
    Z(1)=(index-1-df)*ddf;       % 按式(6-2-6)计算频率
    Z(2)=Amax/sinc(df);          % 按式(6-2-8)计算幅值
    Z(3)=phmax+pi*df;            % 按式(6-2-12)计算初始相角
end
    
%比值法_加Hanning窗
if (WindowType==2)               % 若是海宁窗
    indsecL=A(index-1)>A(index+1);  % 给出X(k-1)>X(k+1)的逻辑量
    % 按式(6-2-29)计算Δk
    df=indsecL.*(2*A(index-1)-Amax)./(Amax+A(index-1))-...
        (1-indsecL).*(2*A(index+1)-Amax)./(Amax+A(index+1));
    Z(1)=(index-1-df)*ddf;       % 按式(6-2-6)计算频率
    Z(2)=(1-df^2)*Amax/sinc(df); % 按式(6-2-31)计算幅值
    Z(3)=phmax+pi*df;            % 按式(6-2-12)计算初始相角
end
Z(3)=mod(Z(3),2*pi);             % 以保证初始相角在-pi~pi的区间中
Z(3)=Z(3)-(Z(3)>pi)*2*pi+(Z(3)<-pi)*2*pi;
