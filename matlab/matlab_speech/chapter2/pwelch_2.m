function [Pxx] = pwelch_2(x, nwind, noverlap, w_nwind, w_noverlap, nfft)
% 计算短时功率谱密度函数
% x是信号，nwind是每帧长度，noverlap是每帧重叠的样点数
% w_nwind是每段的窗函数，或相应的段长，
% w_noverlap是每段之间的重叠的样点数，nfft是FFT的长度

x=x(:);
inc=nwind-noverlap;       % 计算帧移
X=enframe(x,nwind,inc)';  % 分帧
frameNum=size(X,2);       % 计算帧数
%用pwelch函数对每帧计算功率谱密度函数
for k=1 : frameNum
    Pxx(:,k)=pwelch(X(:,k),w_nwind,w_noverlap,nfft);
end



