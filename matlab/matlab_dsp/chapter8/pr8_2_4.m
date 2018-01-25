%
% pr8_2_4 
clc; clear all; close all

load Gpsd_7096.mat                % 读入功率谱密度数值文件
L=length(freq);                   % 正频率长度
N=(L-1)*2;                        % 数据长度
Gxx=Gx;                           % 双边功率谱密度
Gxx(2:L-1)=Gx(2:L-1)/2;           % 把单边功率谱密度幅值变为双边功率谱密度幅值
Ax=sqrt(Gxx*N*fs);                % 计算期望双边频谱幅值
% 用随机数构成相角
fik=pi*randn(1,L);                % 产生随机相位角
Xk=Ax.*exp(1j*fik);               % 产生单边频谱
Xk=[Xk conj(Xk(L-1:-1:2))];       % 利用共轭对称性求出双边频谱
Xm=ifft(Xk);                      % 傅里叶逆变换
xm=real(Xm);                      % 取实部
time=(0:N-1)/fs;                  % 时间序列
% 对随机序列xm求周期图法的功率谱密度
[Gx1,f1]=periodogram(xm,boxcar(N),N,fs,'onesided');
Dgx=max(Gx-Gx1')                  % 计算两功率谱密度最大差值
% 作图
figure(1)
subplot 211; plot(freq,Gx,'k','linewidth',2)
xlabel('频率/Hz'); ylabel('功率谱密度幅值/m^2/(s^4Hz)')
title('期望功率谱密度Gx'); grid; 
subplot 212; plot(freq,Ax,'k','linewidth',2)
xlabel('频率/Hz'); ylabel('加速度频域幅值/m/s^2')
title('期望加速度频域幅值Ax'); grid; 
set(gcf,'color','w'); 


figure(2)
subplot 211; plot(time,xm,'k');
xlabel('时间/s'); ylabel('加速度幅值/m/s^2')
title('激励随机加速度序列波形图'); grid; 
subplot 212; plot(freq,Gx,'r','linewidth',3); hold on
plot(f1,Gx1,'k');
xlabel('频率/Hz'); ylabel('功率谱密度幅值/m^2/(s^4Hz)')
title('期望功率谱密度和随机序列功率谱密度比较'); grid; 
legend('期望功率谱密度','随机序列功率谱密')
set(gcf,'color','w'); 


