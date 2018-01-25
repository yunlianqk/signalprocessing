function Fmap=Formant_ext2(x,wlen,inc,fs,SF,Doption)

y=filter([1 -.99],1,x);                               % 预加重
xy=enframe(y,wlen,inc)';                              % 分帧
fn=size(xy,2);                                        % 求帧数
Nx=length(y);                                         % 数据长度
time=(0:Nx-1)/fs;                                     % 时间刻度
frameTime=frame2time(fn,wlen,inc,fs);                 % 每帧对应的时间刻度
Msf=repmat(SF',1,3);                                  % 把SF扩展为3×fn的数组
Ftmp_map=zeros(fn,3);
warning off
Fsamps = 256;                                         % 设置频域长度
Tsamps= fn;                                           % 设置时域长度
ct = 0;

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

Fmap=Ftmp_map';
findex=find(Fmap==nan);
Fmap(findex)=0;
% 作图
if Doption
figure(99)
nfft=512;
d=stftms(y,wlen,nfft,inc);
W2=1+nfft/2;
n2=1:W2;
freq=(n2-1)*fs/nfft;
Fmap1=Msf.*Ftmp_map;                                  % 只取有话段的数据
findex=find(Fmap1==0);                                % 如果有数值为0 ,设为nan
Fmapd=Fmap1;
Fmapd(findex)=nan;
imagesc(frameTime,freq,abs(d(n2,:)));  axis xy
m = 64; LightYellow = [0.6 0.6 0.6];
MidRed = [0 0 0]; Black = [0.5 0.7 1];
Colors = [LightYellow; MidRed; Black];
colormap(SpecColorMap(m,Colors)); hold on
plot(frameTime,Fmapd,'w');                             % 叠加上共振峰频率曲线
title('在语谱图上标出共振峰频率');
xlabel('时间/s'); ylabel('频率/Hz')
end