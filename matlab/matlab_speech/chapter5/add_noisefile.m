function [y,noise] = add_noisefile(s,filepath_name,SNR,fs)
s=s(:);                             % 把信号转换成列数据
s=s-mean(s);                        % 消除直流分量
[wavin,fs1,nbits]=wavread(filepath_name);   %读入噪声文件的数据
wavin=wavin(:);                     % 把噪声数据转换成列数据
if fs1~=fs                          % 纯语音信号的采样频率与噪声的采样频率不相等
    wavin1=resample(wavin,fs,fs1);  % 对噪声重采样，使噪声采样频率与纯语音信号的采样频率相同
else
    wavin1=wavin;
end
wavin1=wavin1-mean(wavin1);         % 消除直流分量

ns=length(s);                       % 求出s的长度
noise=wavin1(1:ns);                 % 把噪声长度截断为与s等长
noise=noise-mean(noise);            % 噪声去除直流分量
signal_power = 1/ns*sum(s.*s);      % 求出信号的能量
noise_power=1/ns*sum(noise.*noise); % 求出噪声的能量
noise_variance = signal_power / ( 10^(SNR/10) );   % 求出噪声设定的方差值
noise=sqrt(noise_variance/noise_power)*noise;      % 调整噪声幅值
y=s+noise;                          % 构成带噪语音

