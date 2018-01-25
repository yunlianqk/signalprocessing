%
% pr5_1_7 
clear, clc, close all

[x, fs] = wavread('minuniv.wav');   % 读入语音
x = x(:, 1);                        % 只取单通道
x = x/max(abs(x));                  % 幅值归一化
xlen = length(x);                   % 信号长度
t = (0:xlen-1)/fs;                  % 时间序列
wlen = 256;                         % 帧长
inc = wlen/4;                       % 帧移
nfft = wlen;                        % nfft长
% STFT谱分析--Spectrogram
[B, f, t_stft] = mystftfun(x, wlen, inc, nfft, fs);
% STFT逆变换
[x_istft, t_istft] = myistftfun(B, inc, nfft, fs);
slen=length(x_istft);               % 使重构序列与x等长
if slen>xlen, x_istft=x_istft(1:xlen); else x=x(1:slen); t=t_istft; end
Err=x_istft-x';                     % 计算重构序列x_istft与x的偏差
Segma_e=var(Err);                   % 计算重构序列x_istft与x偏差的方差
fprintf('Segma_e=%5.4e\n',Segma_e);
% 作图
figure(1)
imagesc(t_stft,f,abs(B)); axis xy
xlabel('时间/s'); ylabel('频率/Hz')
title('STFT谱图'); 
set(gcf,'color','w');
figure(2)
subplot 211; plot(t, x, 'r')
axis([0 max(t) -1.1 1.1]); grid on
xlabel('时间/s'); ylabel('幅值')
title('原始信号和重构信号'); hold on
plot(t_istft, x_istft, '-.k')
subplot 212; plot(t_istft, Err,'k')
xlabel('时间/s'); ylabel('幅值')
title('原始信号与重构信号的偏差')
xlim([0 max(t)]);
set(gcf,'color','w');
