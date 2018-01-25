%
%  pr9_3_1  
clear all; clc; close all;

fle='snn27.wav';                            % 指定文件名
[x,fs]=wavread(fle);                        % 读入一帧语音信号 
u=filter([1 -.99],1,x);                     % 预加重
wlen=length(u);                             % 帧长
p=12;                                       % LPC阶数
a=lpc(u,p);                                 % 求出LPC系数
U=lpcar2pf(a,255);                          % 由LPC系数求出频谱曲线
freq=(0:256)*fs/512;                        % 频率刻度
df=fs/512;                                  % 频率分辨率
U_log=10*log10(U);                          % 功率谱分贝值
subplot 211; plot(u,'k');                   % 作图
axis([0 wlen -0.5 0.5]);
title('预加重波形');
xlabel('样点数'); ylabel('幅值')
subplot 212; plot(freq,U,'k');
title('声道传递函数功率谱曲线');
xlabel('频率/Hz'); ylabel('幅值');

[Loc,Val]=findpeaks(U);                     % 在U中寻找峰值
ll=length(Loc);                             % 有几个峰值
for k=1 : ll
    m=Loc(k);                               % 设置m-1,m和m+1
    m1=m-1; m2=m+1;
    p=Val(k);                               % 设置P(m-1),P(m)和P(m+1)
    p1=U(m1); p2=U(m2);
    aa=(p1+p2)/2-p;                         % 按式(9-3-4)计算
    bb=(p2-p1)/2;
    cc=p;
    dm=-bb/2/aa;                            % 按式(9-3-6)计算
    pp=-bb*bb/4/aa+cc;                      % 按式(9-3-8)计算
    m_new=m+dm;
    bf=-sqrt(bb*bb-4*aa*(cc-pp/2))/aa;      % 按式(9-3-13)计算
    F(k)=(m_new-1)*df;                      % 按式(9-3-7)计算
    Bw(k)=bf*df;                            % 按式(9-3-14)计算
    line([F(k) F(k)],[0 pp],'color','k','linestyle','-.');
end
fprintf('F =%5.2f   %5.2f   %5.2f   %5.2f\n',F)
fprintf('Bw=%5.2f   %5.2f   %5.2f   %5.2f\n',Bw)
