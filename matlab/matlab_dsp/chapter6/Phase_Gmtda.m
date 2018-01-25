function Z=Phase_Gmtda(x,N,L,M,fs,nx1,nx2,wintype)
if M+2*L-N==0, disp('M+2*L-N不能为0,请重新设置'); return; end
x=x(:)';                        % 把转为行序列
arc=pi/180;                     % 1弧度
u1=x(1:N);                      % 两列数据
u2=x(L+1:L+M);
if wintype==1                   % 矩形窗
    U1=fft(u1);                 % 第1序列FFT
    U2=fft(u2);                 % 第2序列FFT
elseif wintype==2               % 海宁窗
    w1=hann(N,'periodic')';     % 海宁窗函数,长N
    w2=hann(M,'periodic')';     % 海宁窗函数,长M
    U1=fft(u1.*w1);             % 乘窗函数和FFT
    U2=fft(u2.*w2);
end
df1=fs/N;                       % 第1序列分辨率 
df2=fs/M;                       % 第2序列分辨率 
n11=fix(nx1/df1);               % 第1序列U1中搜寻区间 
n12=round(nx2/df1);
n21=fix(nx1/df2);               % 第2序列U2中搜寻区间
n22=round(nx2/df2);

[Umax,index]=max(abs(U1(n11:n12)));  % 第1序列寻找最大值
k1=n11+index-2;                 % 可计算实际频率:k1*df1
UMAX=Umax;                      % 保留最大值的幅值
KMAX=k1;                        % 保留最大值的k1
k2=k1+1;                        % 最大值频率的索引号
angle1=atan2(imag(U1(k2)),real(U1(k2)));% 在四象限中寻找相角

[Umax,index]=max(abs(U2(n21:n22)));  % 第2序列寻找最大值
k1=n21+index-2;                 % 可计算实际频率:k1*df2
k2=k1+1;                        % 最大值频率的索引号
angle2=atan2(imag(U2(k2)),real(U2(k2)));% 在四象限中寻找相角

dangle=angle1-angle2;           % 计算相位差
delta=dangle-pi*(k1-KMAX*M/N)+2*pi*KMAX*L/N;  % 按式(6-4-30)计算delta
del=mod(delta,2*pi);            % 把delta限于2*pi范围内
del=del-(del>pi)*2*pi+(del<-pi)*2*pi; % 把del限于-pi~pi范围内
dk1=-del*N/pi/(N-M-2*L);        % 按式(6-4-31)计算di
dk=dk1+(dk1<-0.5)-(dk1>0.5);    % 把di限于-0.5~0.5范围内

Z(2)=(KMAX-dk)*fs/N;            % 按式(6-4-32)计算频率
Z(3)=angle1+dk*pi;              % 按式(6-4-33)计算初始相角
if wintype==1                   % 按式(6-4-35)计算矩形窗的幅值
    Z(1)=2*UMAX/sinc(dk)/N;
elseif wintype==2               % 按式(6-4-36)计算海宁窗的幅值
    Z(1)=4*UMAX*(1-dk*dk)/sinc(dk)/N;
end


