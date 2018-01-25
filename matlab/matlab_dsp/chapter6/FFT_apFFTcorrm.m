function Z=FFT_apFFTcorrm(y,N,fs,NX1,NX2)
y=y(:)';                       % 把y设为一行序列
win=hanning(N)';               % 海宁窗
y1 = y(N:2*N-1);               % 第1组数据取值
win2 = win/sum(win);           % 归一化
y11= y1.*win2;                 % 乘海宁窗
y11_fft = fft(y11,N);          % FFT
a1 = abs(y11_fft);             % 按式(6-5-11a)求幅值
p1 = mod(phase(y11_fft),2*pi); % 按式(6-5-11b)求相位角

y2 = y(1:2*N-1);               % 第2组数据取值
winn =  conv(win,win);         % 窗函数卷积
win2 = winn/sum(winn);         % 归一化
y22= y2.*win2;                 % 乘海宁卷积窗
y222=y22(N:end)+[0 y22(1:N-1)];% 构成长N的apFFT输入数据序列
y2_fft = fft(y222,N);          % FFT
a2 = abs(y2_fft);              % 按式(6-5-12a)求幅值
p2=mod( phase(y2_fft),2*pi);   % 按式(6-5-12b)求相位角

dp=p1-p2;                      % 求出相位差
dp=dp-(dp>pi)*2*pi+(dp<-pi)*2*pi; % 把del限于-pi~pi范围内
ee=(dp)/pi/(1-1/N);            % 按式(6-5-14)计算频率校正量
aa=(a1.^2)./a2*2;              % 按式(6-5-15)计算信号幅值

df=fs/N;                       % 频率分辨率
mx1=fix(NX1/df)+1;             % 求寻找极大值的谱线索引 
mx2=fix(NX2/df)+1;
[Amax,floc]=max(a2(mx1:mx2));  % 寻找极大值
floc=floc+mx1-1;               % 极大值索引号
fcor=(floc-1)*df;              % 极大值处对应的频率
Z(2)=fcor+ee(floc)*df;         % 计算频率
Z(3)=p2(floc);                 % 计算初始相角
Z(1)=aa(floc);                 % 计算幅值

