function snr=prony_snr(x,y)
N=length(x);                 % x的长度
s1=0; s2=0;                  % 初始化

for k=1 : N
    s1=s1+(x(k)-y(k))^2;     % 计算式(7-4-15)的分母
    s2=s2+x(k)^2;            % 计算式(7-4-15)的分子
end

snr=10*log10(s2/s1);         % 计算式(7-4-15)



