%
% pr5_1_2 
clear all; clc; close all;

fs=1000;                     % 采样频率
tt=(0:1000)'/fs;             % 时间刻度
% 构成信号
x=sin(2*pi*400*tt).*(tt<=0.3)+sin(2*pi*200*tt).*(tt>0.3&tt<=0.6)+...
    sin(2*pi*100*tt).*(tt>0.6&tt<=0.8)+sin(2*pi*50*tt).*(tt>0.8);

N=length(x);                 % 数据长度
nfft=256;                    % 设置nfft
n3=1:128;                    % 设置正频率部分
h=hamming(31);                     % 设置窗长为31
[tfr1,t,f1]=tfrstft(x,1:N,nfft,h); % STFT
h=hamming(63);                     % 设置窗长为63
[tfr2,t,f2]=tfrstft(x,1:N,nfft,h); % STFT
h=hamming(127);                    % 设置窗长为127
[tfr3,t,f3]=tfrstft(x,1:N,nfft,h); % STFT
h=hamming(255);                    % 设置窗长为255
[tfr4,t,f4]=tfrstft(x,1:N,nfft,h); % STFT
% 作图
figure(1)
pos = get(gcf,'Position');
set(gcf,'Position',[pos(1), pos(2)-100,pos(3),(pos(4)-180)]);
plot(tt,x,'k');
xlabel('时间/s'); ylabel('幅值'); title('信号波形图')
set(gcf,'color','w');
figure(2)
subplot 221; contour(tt,f1(n3)*fs,abs(tfr1(n3,:)));
set(gca, 'YTickmode', 'manual', 'YTick', [0,50,100,200,400,500]);
grid; title('窗长=31'); ylabel('频率/Hz'); xlabel('时间/s');
subplot 222; contour(tt,f2(n3)*fs,abs(tfr2(n3,:)));
set(gca, 'YTickmode', 'manual', 'YTick', [0,50,100,200,400,500]);
grid; title('窗长=63'); ylabel('频率/Hz'); xlabel('时间/s');
subplot 223; contour(tt,f3(n3)*fs,abs(tfr3(n3,:)));
set(gca, 'YTickmode', 'manual', 'YTick', [0,50,100,200,400,500]);
grid; title('窗长=127'); ylabel('频率/Hz'); xlabel('时间/s');
subplot 224; contour(tt,f4(n3)*fs,abs(tfr4(n3,:)));
set(gca, 'YTickmode', 'manual', 'YTick', [0,50,100,200,400,500]);
grid; title('窗长=255'); ylabel('频率/Hz'); xlabel('时间/s');
set(gcf,'color','w');



