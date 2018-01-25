function Z=phase1_afterexzfft(xx,fi,Nw,Lw,fs1,nx1,nx2)
if nargin<7,  disp('输入参数少于7个,请补充参数'); return; end

xx=xx(:).';                  % 把x转成为行序列
ddf=fs1/Nw;                  % 计算出频率分辨率
u1=xx(1:Nw);                 % 两列数据
u2=xx(Lw+1:Lw+Nw);
w=hanning(Nw);               % 海宁窗函数

U1=fft(u1.*w');              % 数据乘窗函数后FFT
U1=fftshift(U1);             % 频域重新排列
U2=fft(u2.*w');              % 数据乘窗函数后FFT
U2=fftshift(U2);             % 频域重新排列
if nx1-fi<=0, nx1=fi; end
n1=floor((nx1-fi)/ddf)+1;
n2=floor((nx2-fi)/ddf)+1;

[Umax,index]=max(abs(U1(n1:n2)));  % 第1序列寻找最大值
k1=n1+index-2;               % 可计算实际频率:k1*df1
UMAX=Umax;                   % 保留最大值的幅值
KMAX=k1;                     % 保留k1
k2=k1+1;
angle1=atan2(imag(U1(k2)),real(U1(k2)));% 在四象限中寻找相角

[Umax,index]=max(abs(U2(n1:n2)));  % 第2序列寻找最大值
k1=n1+index-2;               % 可计算实际频率:k1*df2
k2=k1+1;                     % 最大值频率的索引号
angle2=atan2(imag(U2(k2)),real(U2(k2)));% 在四象限中寻找相角

dangle=angle2-angle1;        % 计算相位差
delta=2*pi*KMAX*Lw/Nw-dangle;  % 按式(6-4-17)计算delta
del=mod(delta,2*pi);         % 把delta限于2*pi范围内
del=del-(del>pi)*2*pi+(del<-pi)*2*pi; % 把del限于-pi~pi范围内
dk1=del/2/pi/(Lw/Nw);        % 按式(6-4-17)计算di
dk=dk1+(dk1<-0.5)-(dk1>0.5); % 把di限于-0.5~0.5范围内

Z(2)=(KMAX-dk)*ddf+fi;       % 按式(6-4-32)计算频率并加上初始值
Z(3)=angle1+dk*pi;           % 按式(6-4-33)计算初始相角
Z(1)=4*UMAX*(1-dk*dk)/sinc(dk)/Nw;  % 按式(6-2-21)求出海宁窗条件下的幅值

