% 
% pr3_13_2 
clear all; clc; close all

Fs=1000;                                   % 采样频率
Fs2=Fs/2;                                  % 奈奎斯特频率
fs1=100; fp1=175;                          % 通带和阻带频率
fp2=275; fs2=350;
ws1 = fs1*pi/Fs2; wp1 = fp1*pi/Fs2;        % 通带和阻带归一化角频率
wp2 = fp2*pi/Fs2; ws2 = fs2*pi/Fs2;
tr_width = min((wp1-ws1),(ws2-wp2));       % 过渡带宽Δω的计算
M = ceil(6.2*pi/tr_width);                 % 按海明窗计算所需的滤波器阶数N
M=M+mod(M+1,2);                            % 保证滤波器系数长N+1为奇数
% 用ideal_lp函数
wc1 = (ws1+wp1)/2; wc2 = (wp2+ws2)/2;      % 求截止频率的归一化角频率
hd = ideal_lp(wc2,M) - ideal_lp(wc1,M);    % 用ideal_lp函数计算理想滤波器脉冲响应
w_ha = (hanning(M))';                      % 海宁窗函数
h = hd .* w_ha;                            % FIR滤波器脉冲响应
[db,mag,pha,grd,w] = freqz_m(h,[1]);       % 求出频域响应
delta_w = 2*pi/1000;                       % 频域角频率间隔
Rp = -min(db(wp1/delta_w+1:1:wp2/delta_w));% 通带实际波纹值
As = -round(max(db(ws2/delta_w+1:1:501))); % 阻带衰减值
% 用fir1函数
fc1 = wc1/pi; fc2=wc2/pi;                  % 求截止频率归一化值
h1 = fir1(M-1,[fc1 fc2],hanning(M)');      % 用fir1函数计算理想滤波器脉冲响应
[db1,mag,pha,grd,w1] = freqz_m(h1,[1]);    % 求出频域响应
% 作图
subplot 211;plot(w*Fs2/pi,db,'r','linewidth',2); hold on
plot(w1*Fs2/pi,db1,'k');
title('带通滤波器幅值响应');grid;
xlabel('频率/Hz'); ylabel('幅值/dB')
legend('ideal_lp函数','fir1函数')
axis([0 Fs2 -60 10]); 
set(gca,'XTickMode','manual','XTick',[0,100,175,275,350,500])
set(gca,'YTickMode','manual','YTick',[-30,0])

n=1:M;
subplot 212; plot(n,h,'r','linewidth',2); hold on; 
plot(n,h1,'k')
title('带通滤波器脉冲响应')
legend('ideal_lp函数','fir1函数')
axis([0 M-1 -0.4 0.5]); xlabel('样点'); ylabel('幅值')
set(gcf,'color','w');
