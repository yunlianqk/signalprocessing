function Z=apFFTcorrm(s,N,L,fs,NX1,NX2)
if length(s)<2*N+L-1, disp('数据太短了,数据必须长2N+L-1!!');  return; end
s=s(:)';                       % 把s设为一行序列
df=fs/N;                       % 频率分辨率
win=hanning(N)';               % 海宁窗1
win1=hann(N)';                 % 海宁窗2
win2=conv(win,win1);           % 窗函数卷积
win2=win2/sum(win2);           % 归一化
s1=s(1:2*N-1);                 % 第1组数据取值
y1=s1.*win2;                   % 乘海宁卷积窗
y1a=y1(N:end)+[0 y1(1:N-1)];   % 构成长N的apFFT输入数据序列
Y1=fft(y1a,N);                 % FFT
a1=abs(Y1);                    % 按式(6-5-16a)求幅值
p1=mod(phase(Y1),2*pi);        % 按式(6-5-16b)求相位角

s2=s(1+L:2*N+L-1);             % 第2组数据取值
y2=s2.*win2;                   % 乘海宁卷积窗
y2a=y2(N:end)+[0 y2(1:N-1)];   % 构成长N的apFFT输入数据序列
Y2=fft(y2a,N);                 % FFT
a2=abs(Y2);                    % 按式(6-5-17a)求幅值
p2=mod(phase(Y2),2*pi);        % 按式(6-5-17b)求相位角

mx1=fix(NX1/df)+1;             % 求寻找极大值的谱线索引
mx2=fix(NX2/df)+1;
[fm,fl]=max(a1(mx1:mx2));      % 寻找极大值
fl=fl+mx1-1;                   % 极大值索引号
rr=fl-1;                       % 用于频率计算
dp=p1(fl)-p2(fl);              % 按式(6-5-20)计算相位差
dp=mod(dp,2*pi);               % 把相位差限于2*pi以内
dp=dp-(dp>pi)*2*pi+(dp<-pi)*2*pi; % 把del限于-pi~pi范围内
dk1=dp*N/L/2/pi;               % 按式(6-5-22)计算dk
dk1=mod(dk1,1);
dk=dk1+(dk1<-0.5)-(dk1>0.5);   % 把di限于-0.5~0.5范围内
Z(2)=(rr-dk)*df;               % 按式(6-5-23)计算频率
Z(3)=p1(fl);                   % 按式(6-5-18)计算初始相位角
Wk=(1-dk*dk)/sinc(dk);         % 海宁窗幅值
Z(1)=2*abs((Wk^2)*a2(fl));     % 按式(6-5-24)计算幅值



