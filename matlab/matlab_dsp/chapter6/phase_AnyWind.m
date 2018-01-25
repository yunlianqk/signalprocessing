function Z=phase_AnyWind(x,N,L,M,fs,nx1,nx2,wind1,wind2)
if nargin<9,  disp('输入参数少于9个,请补充参数'); return; end

x=x(:)';                     % 把x转成为行序列
u1=x(1:N);                   % 两列数据
u2=x(L+1:L+M);
w1=wind1(:)';                % 第1段的窗函数
w2=wind2(:)';                % 第2段的窗函数
U1=fft(u1.*w1);              % 数据乘窗函数后FFT
U2=fft(u2.*w2);

df1=fs/N;                    % 第1序列分辨率 
df2=fs/M;                    % 第2序列分辨率 
n11=fix(nx1/df1);            % 第1序列U1中搜寻区间 
n12=round(nx2/df1);
n21=fix(nx1/df2);            % 第2序列U2中搜寻区间
n22=round(nx2/df2);

[Umax,index]=max(abs(U1(n11:n12)));  % 第1序列寻找最大值
k1=n11+index-2;              % 可计算实际频率:k1*df1
UMAX=Umax;                   % 保留最大值的幅值
KMAX=k1;                     % 保留k1
k2=k1+1;                     % 最大值频率的索引号
angle1=atan2(imag(U1(k2)),real(U1(k2)));% 在四象限中寻找相角

[Umax,index]=max(abs(U2(n21:n22)));  % 第2序列寻找最大值
k1=n21+index-2;              % 可计算实际频率:k1*df2
k2=k1+1;                     % 最大值频率的索引号
angle2=atan2(imag(U2(k2)),real(U2(k2)));% 在四象限中寻找相角

dangle=angle1-angle2;        % 计算相位差
delta=dangle-pi*(k1-KMAX*M/N)+2*pi*KMAX*L/N;  % 按式(6-4-30)计算delta
del=mod(delta,2*pi);         % 把delta限于2*pi范围内
del=del-(del>pi)*2*pi+(del<-pi)*2*pi; % 把del限于-pi~pi范围内
dk1=-del*N/pi/(N-M-2*L);     % 按式(6-4-31)计算di
dk=dk1+(dk1<-0.5)-(dk1>0.5); % 把di限于-0.5~0.5范围内

Z(2)=(KMAX-dk)*fs/N;         % 按式(6-4-32)计算频率
Z(3)=angle1+dk*pi;           % 按式(6-4-33)计算初始相角
Wdk=dtft_dkm(w1,dk,1);       % 求出W(dk)
WA=abs(Wdk);                 % 取模值
Z(1)=2*UMAX/WA/N;            % 求出任意窗条件下的幅值



