%
% pr9_3_2  
clear all; clc; close all;

fle='snn27.wav';                            % 指定文件名
[xx,fs]=wavread(fle);                       % 读入一帧语音信号
u=filter([1 -.99],1,xx);                    % 预加重
wlen=length(u);                             % 帧长
p=12;                                       % LPC阶数
a=lpc(u,p);                                 % 求出LPC系数
U=lpcar2pf(a,255);                          % 由LPC系数求出功率谱曲线
freq=(0:256)*fs/512;                        % 频率刻度
df=fs/512;                                  % 频率分辨率
U_log=10*log10(U);                          % 功率谱分贝值
subplot 211; plot(u,'k');                   % 作图
axis([0 wlen -0.5 0.5]);
title('预加重波形');
xlabel('样点数'); ylabel('幅值')
subplot 212; plot(freq,U_log,'k');
title('声道传递函数功率谱曲线');
xlabel('频率/Hz'); ylabel('幅值/dB');

n_frmnt=4;                                  % 取四个共振峰
const=fs/(2*pi);                            % 常数  
rts=roots(a);                               % 求根
k=1;                                        % 初始化
yf = [];
bandw=[];
for i=1:length(a)-1                     
    re=real(rts(i));                        % 取根之实部
    im=imag(rts(i));                        % 取根之虚部
    formn=const*atan2(im,re);               % 按(9-3-17)计算共振峰频率
    bw=-2*const*log(abs(rts(i)));           % 按(9-3-18)计算带宽
    
    if formn>150 & bw <700 & formn<fs/2     % 满足条件方能成共振峰和带宽
        yf(k)=formn;
        bandw(k)=bw;
        k=k+1;
    end
end

[y, ind]=sort(yf);                          % 排序
bw=bandw(ind);
F = [NaN NaN NaN NaN];                      % 初始化
Bw = [NaN NaN NaN NaN];
F(1:min(n_frmnt,length(y))) = y(1:min(n_frmnt,length(y)));   % 输出最多四个
Bw(1:min(n_frmnt,length(y))) = bw(1:min(n_frmnt,length(y))); % 输出最多四个
F0 = F(:);                                  % 按列输出
Bw = Bw(:);
p1=length(F0);                              % 在共振峰处画线
for k=1 : p1
    m=floor(F0(k)/df);
    P(k)=U_log(m+1);
    line([F0(k) F0(k)],[-10 P(k)],'color','k','linestyle','-.');
end
fprintf('F0=%5.2f   %5.2f   %5.2f   %5.2f\n',F0);
fprintf('Bw=%5.2f   %5.2f   %5.2f   %5.2f\n',Bw);

