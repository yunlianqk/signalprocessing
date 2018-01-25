function [TT,FF,Ef,SF,voiceseg,vosl,vseg,vsl,Thr2]=...
   Ext_F0ztms(xx,fs,wlen,inc,Thr1,r2,miniL,mnlong,ThrC,doption)

N=length(xx);                             % 信号长度
time = (0 : N-1)/fs;                      % 设置时间刻度
lmin=floor(fs/500);                       % 最高基音频率500Hz对应的基音周期
lmax=floor(fs/60);                        % 最高基音频率60Hz对应的基音周期 

yy=enframe(xx,wlen,inc)';                 % 第一次分帧
fn=size(yy,2);                            % 取来总帧数
frameTime = frame2time(fn, wlen, inc, fs);% 计算每一帧对应的时间
% 用于基音检测的端点检测和元音主体检测
[voiceseg,vosl,vseg,vsl,Thr2,Bth,SF,Ef]=pitch_vads(yy,fn,Thr1,r2,miniL,mnlong);
% 60～500Hz的带通滤波器系数
b=[0.012280   -0.039508   0.042177   0.000000   -0.042177   0.039508   -0.012280];
a=[1.000000   -5.527146   12.854342   -16.110307   11.479789   -4.410179   0.713507];
x=filter(b,a,xx);                         % 数字滤波
x=x/max(abs(x));                          % 幅值归一化
y=enframe(x,wlen,inc)';                   % 第二次分帧

[Extseg,Dlong]=Extoam(voiceseg,vseg,vosl,vsl,Bth);   % 计算延伸区间和延伸长度
T1=ACF_corrbpa(y,fn,vseg,vsl,lmax,lmin,ThrC(1));     % 对元音主体进行基音检测
% 对语音主体的前后向过渡区延伸基音检测        
T0=zeros(1,fn);                           % 初始化
F0=zeros(1,fn);
for k=1 : vsl                             % 共有vsl个元音主体
    ix1=vseg(k).begin;                    % 第k个元音主体开始位置
    ix2=vseg(k).end;                      % 第k个元音主体结束位置
    in1=Extseg(k).begin;                  % 第k个元音主体前向延伸开始位置
    in2=Extseg(k).end;                    % 第k个元音主体后向延伸结束位置
    ixl1=Dlong(k,1);                      % 前向延伸长度
    ixl2=Dlong(k,2);                      % 后向延伸长度
    if ixl1>0                             % 需要前向延伸基音检测
        [Bt,voiceseg]=back_Ext_shtpm1(y,fn,voiceseg,Bth,ix1,...
        ixl1,T1,k,lmax,lmin,ThrC);
    else                                  % 不需要前向延伸基音检测
        Bt=[];
    end
    if ixl2>0                             % 需要后向延伸基音检测
        [Ft,voiceseg]=fore_Ext_shtpm1(y,fn,voiceseg,Bth,ix2,...
        ixl2,vsl,T1,k,lmax,lmin,ThrC);
    else                                  % 不需要后向延伸基音检测
        Ft=[];
    end
    T0(in1:in2)=[Bt T1(ix1:ix2) Ft];      % 第k个元音主体完成了前后向延伸检测 
end
SF=zeros(1,fn);
for k=1 : vosl
    SF(voiceseg(k).begin:voiceseg(k).end)=1;
end
tindex=find(T0>lmax);                     % 限止延伸后最大基音周期值不超越lmax
T0(tindex)=lmax;
tindex=find(T0<lmin & T0~=0);             % 限止延伸后最小基音周期值不低于lmin
T0(tindex)=lmin;
tindex=find(T0~=0);
F0(tindex)=fs./T0(tindex);
TT=pitfilterm1(T0,Extseg,vsl);             % T0平滑滤波
FF=pitfilterm1(F0,Extseg,vsl);             % F0平滑滤波
% STFT分析,绘制语谱图
nfft=512;
d=stftms(xx,wlen,nfft,inc);
W2=1+nfft/2;
n2=1:W2;
freq=(n2-1)*fs/nfft;

% 作图
if doption
    figure(101)
    pos = get(gcf,'Position');
    set(gcf,'Position',[pos(1), pos(2)-100,pos(3),pos(4)+85]);
    subplot 411; plot(time,xx,'k');
    title('原始信号波形'); axis([0 max(time) -1 1]); ylabel('幅值')
    for k=1 : vosl
        line([frameTime(voiceseg(k).begin) frameTime(voiceseg(k).begin)],...
        [-1 1],'color','k');
        line([frameTime(voiceseg(k).end) frameTime(voiceseg(k).end)],...
        [-1 1],'color','k','linestyle','--');
    end
    subplot 412; plot(frameTime,Ef,'k'); hold on
    title('能熵比'); axis([0 max(time) 0 max(Ef)]); ylabel('幅值')
    line([0 max(frameTime)],[Thr1 Thr1],'color','k','linestyle','--');
    plot(frameTime,Thr2,'k','linewidth',2);
    for k=1 : vsl
        line([frameTime(vseg(k).begin) frameTime(vseg(k).begin)],...
        [0 max(Ef)],'color','k','linestyle','-.');
        line([frameTime(vseg(k).end) frameTime(vseg(k).end)],...
        [0 max(Ef)],'color','k','linestyle','-.');
    end
    subplot 413; plot(frameTime,TT,'k');
    title('基音周期'); grid; xlim([0 max(time)]); ylabel('样点值')
    subplot 414; plot(frameTime,FF,'k'); 
    title('基音频率'); grid; xlim([0 max(time)]); 
    xlabel('时间/s'); ylabel('频率/Hz')

    figure(102)
    pos = get(gcf,'Position');
    set(gcf,'Position',[pos(1), pos(2)-100,pos(3),(pos(4)-240)]);
    imagesc(frameTime,freq,abs(d(n2,:)));  axis xy
    m = 64; LightYellow = [0.6 0.6 0.6];
    MidRed = [0 0 0]; Black = [0.5 0.7 1];
    Colors = [LightYellow; MidRed; Black];
    colormap(SpecColorMap(m,Colors));
    hold on
    plot(frameTime,FF,'w');
    ylim([0 1000]);
    title('语谱图上的基音频率曲线');
    xlabel('时间/s'); ylabel('频率/Hz')
end






