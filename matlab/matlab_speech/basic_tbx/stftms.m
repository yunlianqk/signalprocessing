function d=stftms(x,win,nfft,inc)
if length(win)==1          % 判断有否设置窗函数
    wlen=win;              % 否，设帧长
    win=hanning(wlen);     % 设置窗函数
else
    wlen=length(win);      % 设帧长
end
x=x(:); win=win(:);        % 把x和win都变为列数组
s = length(x);             % 计算x的长度

c = 1;
d = zeros((1+nfft/2),1+fix((s-wlen)/inc));   % 初始化输出数组
 
for b = 0:inc:(s-wlen)           % 设置循环
  u = win.*x((b+1):(b+wlen));    % 取来一帧数据加窗
  t = fft(u,nfft);               % 进行傅里叶变换
  d(:,c) = t(1:(1+nfft/2));      % 取1到1+nfft/2之间的谱值
  c = c+1;                       % 改变帧数，求取下一帧
end;
