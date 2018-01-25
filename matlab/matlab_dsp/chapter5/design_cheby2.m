function [b,a]=design_cheby2
fs=8000;                       % 采样频率
fs2=fs/2;
Wp=[500 1600]/fs2;             % 通带参数
Ws=[300 1800]/fs2;             % 阻带参数
Rp=1; Rs=40;                   % 波纹系数
[n,Wn]=cheb2ord(Wp,Ws,Rp,Rs);  % 求n和Wn
[b,a]=cheby2(n,Rs,Wn);         % 求滤波器系数b和a