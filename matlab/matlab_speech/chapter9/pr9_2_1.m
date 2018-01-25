%
% pr9_2_1
clear all; clc; close all;

waveFile='snn27.wav';                            % 设置文件名
[x, fs, nbits]=wavread(waveFile);                % 读入一帧数据
u=filter([1 -.99],1,x);                          % 预加重
wlen=length(u);                                  % 帧长
cepstL=6;                                        % 倒频率上窗函数的宽度
wlen2=wlen/2;               
freq=(0:wlen2-1)*fs/wlen;                        % 计算频域的频率刻度
u2=u.*hamming(wlen);		                     % 信号加窗函数
U=fft(u2);                                       % 按式(9-2-1)计算
U_abs=log(abs(U(1:wlen2)));                      % 按式(9-2-2)计算
Cepst=ifft(U_abs);                               % 按式(9-2-3)计算
cepst=zeros(1,wlen2);           
cepst(1:cepstL)=Cepst(1:cepstL);                 % 按式(9-2-5)计算
cepst(end-cepstL+2:end)=Cepst(end-cepstL+2:end);
spect=real(fft(cepst));                          % 按式(9-2-6)计算
[Loc,Val]=findpeaks(spect);                      % 寻找峰值
FRMNT=freq(Loc);                                 % 计算出共振峰频率
% 作图
pos = get(gcf,'Position');
set(gcf,'Position',[pos(1), pos(2)-100,pos(3),(pos(4)-140)]);
plot(freq,U_abs,'k'); 
hold on; axis([0 4000 -6 2]); grid;
plot(freq,spect,'k','linewidth',2); 
xlabel('频率/Hz'); ylabel('幅值/dB');
title('信号频谱,包络线和共振峰值')
fprintf('%5.2f   %5.2f   %5.2f   %5.2f\n',FRMNT);
for k=1 : 4
    plot(freq(Loc(k)),Val(k),'kO','linewidth',2);
    line([freq(Loc(k)) freq(Loc(k))],[-6 Val(k)],'color','k',...
        'linestyle','-.','linewidth',2);
end
