function plot_spectrogram(x,wlen,inc,nfft,fs)

if nargin<5, fs=1; end                    % 若没有输入fs,设fs=1
d=stftms(x,wlen,nfft,inc);                % 短时傅里叶变换
W2=1+nfft/2;                              % 正频率的长度
n2=1:W2;
freq=(n2-1)*fs/nfft;                      % 计算频率
fn=size(d,2);                             % 总帧数
frameTime=frame2time(fn,wlen,inc,fs);     % 计算每帧对应的时间
imagesc(frameTime,freq,abs(d(n2,:)));  axis xy % 作图
m = 64; LightYellow = [0.6 0.6 0.6];
MidRed = [0 0 0]; Black = [0.5 0.7 1];
Colors = [LightYellow; MidRed; Black];
colormap(SpecColorMap(m,Colors));
