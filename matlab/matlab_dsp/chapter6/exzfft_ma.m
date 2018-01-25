function [y,freq,c]=exzfft_ma(x,fe,fs,nfft,D)
nt=length(x);           % 计算读入数据长度
fi=fe-fs/D/2;           % 计算细化截止频率下限
fa=fi+fs/D;             % 计算细化截止频率上限
na=round(0.5 * nt/D+1); % 确定低通滤波器截止频率对应的谱线条数
% 频移
n=0: nt-1;              % 建一个递增向量
b=n*pi* (fi+fa)/fs;     % 设置单位旋转因子
y=x.*exp(-1i*b);        % 进行频移 
b= fft(y, nt);          % FFT
% 低通滤波和下采样
a(1: na) =b(1: na);     % 取正频率部分的低频成分
a(nt-na+2 : nt) =b(nt-na+2 : nt); % 取负频率部分的低频成分
b=ifft(a, nt);          % IFFT 
c=b(1 : D: nt);         % 下采样
% 求细化频谱
y=fft(c, nfft) * 2/nfft;% 再一次FFT
y=fftshift(y);          % 重新排列
freq=fi+(0:nfft-1)*fs/D/nfft; % 频率设置

