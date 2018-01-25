function [xz,fz]=zoomffta(x,fs,N,fe,D,a)
M=round(4*D/a);                   % 滤波器半阶数
k=1:M;                          
w=0.5+0.5*cos(pi*k/M);            % Hanning窗(半窗)

% 求取理想带通滤波器上下界；
fl=max(fe-fs/(4*D),-fs/2);
fh=min(fe+fs/(4*D),fs/2);

% 求取扩展带通滤波器上下界；
hfl=fl-(fh-fl)*a/2;
hfh=fh+(fh-fl)*a/2;

%构造扩展带通滤波器；
wl=2*pi*hfl/fs;                   % hfl和hfh归一化角频率
wh=2*pi*hfh/fs;
hr(1)=(wh-wl)/pi;                 % 按式(5-2-18a)计算复解析带通滤波器实部
hr(2:M+1)=(sin(wh*k)-sin(wl*k))./(pi*k).*w;
hi(1)=0;                          % 按式(5-2-18a)计算复解析带通滤波器虚部
hi(2:M+1)=(cos(wl*k)-cos(wh*k))./(pi*k).*w;

%重采样和滤波
for k=1:N
    kk=(k-1)*D+M; 
    xrz(k)=x(kk+1)*hr(1)+sum(hr(2:M+1).*(x(kk+2:kk+M+1)+x(kk:-1:kk-M+1)));
    xiz(k)=x(kk+1)*hi(1)+sum(hi(2:M+1).*(-x(kk+2:kk+M+1)+x(kk:-1:kk-M+1)));
end

%移频，把fl移到0频
yf=D*fl/fs;                       % 移频量
xz=(xrz+1j*xiz).*exp(-1j*2*pi*(0:N-1)*yf); % 移频

xz=fft(xz);                      % FFT
xz=xz(1:N/2)/N;                  % 取细化复数谱
fz=(0:N/2-1)*fs/N/D+fl;          % 计算细化谱对应的频率
