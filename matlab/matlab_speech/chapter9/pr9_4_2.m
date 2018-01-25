%
% pr9_4_2 
clear all; clc; close all;

filedir=[];                                           % 设置语音文件路径
filename='vowels8.wav';                               % 设置文件名
fle=[filedir filename]
[x, fs, nbits]=wavread(fle);                          % 读入语音文件
y=filter([1 -.99],1,x);                               % 预加重
wlen=200;                                             % 设置帧长
inc=80;                                               % 设置帧移
xy=enframe(y,wlen,inc)';                              % 分帧
fn=size(xy,2);                                        % 求帧数
Nx=length(y);                                         % 数据长度
time=(0:Nx-1)/fs;                                     % 时间刻度
frameTime=frame2time(fn,wlen,inc,fs);                 % 每帧对应的时间刻度
T1=0.1;                                               % 判断有话段的能熵比阈值
miniL=10;                                             % 有话段的最小帧数
[voiceseg,vosl,SF,Ef]=pitch_vad1(xy,fn,T1,miniL);     % 端点检测
Msf=repmat(SF',1,3);                                  % 把SF扩展为3×fn的数组
Fsamps = 256;                                         % 设置频域长度
Tsamps= fn;                                           % 设置时域长度
ct = 0;
warning off
numiter = 10;                                         % 循环10次,
iv=2.^(10-10*exp(-linspace(2,10,numiter)/1.9));       % 在0～1024之间计算出10个数
for j=1:numiter
    i=iv(j);                                          
    iy=fix(length(y)/round(i));                       % 计算帧数
    [ft1] = seekfmts1(y,iy,fs,10);                    % 已知帧数提取共振峰
    ct = ct+1;
    ft2(:,:,ct) = interp1(linspace(1,length(y),iy)',...% 把ft1数据内插为Tsamps长
    Fsamps*ft1',linspace(1,length(y),Tsamps)')';
end
ft3 = squeeze(nanmean(permute(ft2,[3 2 1])));         % 重新排列和平均处理
tmap = repmat([1:Tsamps]',1,3);
Fmap=ones(size(tmap))*nan;                            % 初始化
idx = find(~isnan(sum(ft3,2)));                       % 寻找非nan的位置
fmap = ft3(idx,:);                                    % 存放非nan的数据

[b,a] = butter(9,0.1);                                % 设计低通滤波器
fmap1 = round(filtfilt(b,a,fmap));                    % 低通滤波
fmap2 = (fs/2)*(fmap1/256);                           % 恢复到实际频率
Ftmp_map(idx,:)=fmap2;                                % 输出数据

Fmap1=Msf.*Ftmp_map;                                  % 只取有话段的数据
findex=find(Fmap1==0);                                % 如果有数值为0 ,设为nan
Fmap=Fmap1;
Fmap(findex)=nan;

nfft=512;                                             % 计算语谱图
d=stftms(y,wlen,nfft,inc);
W2=1+nfft/2;
n2=1:W2;
freq=(n2-1)*fs/nfft;
% 作图
figure(1)                                             % 画信号的波形图和能熵比图
subplot 211; plot(time,x,'k');
title('\a-i-u\三个元音的语音的波形图');
xlabel('时间/s'); ylabel('幅值'); xlim([0 max(time)]);
subplot 212; plot(frameTime,Ef,'k'); hold on
line([0 max(time)],[T1 T1],'color','k','linestyle','--');
title('归一化的能熵比图'); axis([0 max(time) 0 1.2]);
xlabel('时间/s'); ylabel('幅值')
for k=1 : vosl
    in1=voiceseg(k).begin;
    in2=voiceseg(k).end;
    it1=frameTime(in1);
    it2=frameTime(in2);
    line([it1 it1],[0 1.2],'color','k','linestyle','-.');
    line([it2 it2],[0 1.2],'color','k','linestyle','-.');
end

figure(2)                                             % 画语音信号的语谱图
imagesc(frameTime,freq,abs(d(n2,:)));  axis xy
m = 64; LightYellow = [0.6 0.6 0.6];
MidRed = [0 0 0]; Black = [0.5 0.7 1];
Colors = [LightYellow; MidRed; Black];
colormap(SpecColorMap(m,Colors)); hold on
plot(frameTime,Fmap,'w');                             % 叠加上共振峰频率轨迹
title('在语谱图上标出共振峰频率');
xlabel('时间/s'); ylabel('频率/Hz')
