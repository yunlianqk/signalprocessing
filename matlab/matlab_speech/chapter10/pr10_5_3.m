%
% pr10_5_3 
clear all; clc; close all;

filedir=[];                               % 设置数据文件的路径
filename='colorcloud.wav';                % 设置数据文件的名称
fle=[filedir filename]                    % 构成路径和文件名的字符串
[xx,fs]=wavread(fle);                     % 读取文件
xx=xx-mean(xx);                           % 去除直流分量
x1=xx/max(abs(xx));                       % 归一化
x=filter([1 -.99],1,x1);                  % 预加重
N=length(x);                              % 数据长度
time=(0:N-1)/fs;                          % 信号的时间刻度
wlen=240;                                 % 帧长
inc=80;                                   % 帧移
overlap=wlen-inc;                         % 重叠长度
tempr1=(0:overlap-1)'/overlap;            % 斜三角窗函数w1
tempr2=(overlap-1:-1:0)'/overlap;         % 斜三角窗函数w2
n2=1:wlen/2+1;                            % 正频率的下标值
wind=hanning(wlen);                       % 窗函数
X=enframe(x,wlen,inc)';                   % 分帧
fn=size(X,2);                             % 帧数
Etemp=sum(X.*X);                          % 计算每帧的能量
Etemp=Etemp/max(Etemp);                   % 能量归一化
T1=0.1; r2=0.5;                           % 端点检测参数
miniL=10;                                 % 有话段最短帧数
mnlong=5;                                 % 元音主体最短帧数
ThrC=[10 15];                             % 阈值
p=12;                                     % LPC阶次
frameTime=frame2time(fn,wlen,inc,fs);     % 每帧对应的时间刻度
Doption=0;                                

% 用主体-延伸法基音检测
[Dpitch,Dfreq,Ef,SF,voiceseg,vosl,vseg,vsl,T2]=...
   Ext_F0ztms(x1,fs,wlen,inc,T1,r2,miniL,mnlong,ThrC,Doption);

%% 共振峰提取
Frmt=Formant_ext2(x,wlen,inc,fs,SF,Doption);
Bwm=[150 200 250];                        % 设置固定带宽                    
Bw=repmat(Bwm',1,fn);

%% 语音合成
zint=zeros(2,4);                          % 初始化
tal=0;
for i=1 : fn
    yf=Frmt(:,i);                         % 取来i帧的三个共振峰频率和带宽
    bw=Bw(:,i);
    [an,bn]=formant2filter4(yf,bw,fs);    % 转换成四个二阶滤波器系数
    synt_frame=zeros(wlen,1);
    
    if SF(i)==0                           % 无话帧
        excitation=randn(wlen,1);         % 产生白噪声
        for k=1 : 4                       % 对四个滤波器并联输入
            An=an(:,k);
            Bn=bn(k);
            [out(:,k),zint(:,k)]=filter(Bn(1),An,excitation,zint(:,k));
            synt_frame=synt_frame+out(:,k); % 四个滤波器输出叠加在一起
        end
    else                                  % 有话帧
        PT=round(Dpitch(i));              % 取周期值
        exc_syn1 =zeros(wlen+tal,1);      % 初始化脉冲发生区
        exc_syn1(mod(1:tal+wlen,PT)==0)=1;% 在基音周期的位置产生脉冲，幅值为1
        exc_syn2=exc_syn1(tal+1:tal+inc); % 计算帧移inc区间内的脉冲个数
        index=find(exc_syn2==1);
        excitation=exc_syn1(tal+1:tal+wlen);% 这一帧的激励脉冲源
        
        if isempty(index)                 % 帧移inc区间内没有脉冲
            tal=tal+inc;                  % 计算下一帧的前导零点
        else                              % 帧移inc区间内有脉冲
            eal=length(index);            % 计算有几个脉冲
            tal=inc-index(eal);           % 计算下一帧的前导零点
        end
        for k=1 : 4                       % 对四个滤波器并联输入
            An=an(:,k);
            Bn=bn(k);
            [out(:,k),zint(:,k)]=filter(Bn(1),An,excitation,zint(:,k));
            synt_frame=synt_frame+out(:,k); % 四个滤波器输出叠加在一起
        end
    end
    Et=sum(synt_frame.*synt_frame);       % 用能量归正合成语音
    rt=Etemp(i)/Et;
    synt_frame=sqrt(rt)*synt_frame;
        if i==1                           % 若为第1帧
            output=synt_frame;            % 不需要重叠相加,保留合成数据
        else
            M=length(output);             % 按线性比例重叠相加处理合成数据
            output=[output(1:M-overlap); output(M-overlap+1:M).*tempr2+...
                synt_frame(1:overlap).*tempr1; synt_frame(overlap+1:wlen)];
        end
end
ol=length(output);                        % 把输出output延长至与输入信号xx等长
if ol<N
    output=[output; zeros(N-ol,1)];
end
% 合成语音通过带通滤波器
out1=output;
out2=filter(1,[1 -0.99],out1);
b=[0.964775   -3.858862   5.788174   -3.858862   0.964775];
a=[1.000000   -3.928040   5.786934   -3.789685   0.930791];
output=filter(b,a,out2);
output=output/max(abs(output));
% 通过声卡发音,比较原始语音和合成语音
wavplay(xx,fs);
pause(1)
wavplay(output,fs);
%% 作图
figure(1)
figure(1)
pos = get(gcf,'Position');
set(gcf,'Position',[pos(1), pos(2)-100,pos(3),(pos(4)+85)])
subplot 411; plot(time,x1,'k'); axis([0 max(time) -1 1.1]);
title('信号波形'); ylabel('幅值')
subplot 412; plot(frameTime,Ef,'k'); hold on
axis([0 max(time) 0 1.2]); plot(frameTime,T2,'k','linewidth',2);
line([0 max(time)],[T1 T1],'color','k','linestyle','-.');
title('能熵比图'); axis([0 max(time) 0 1.2]); ylabel('幅值')
text(3.2,T1+0.05,'T1');
for k=1 : vsl
        line([frameTime(vseg(k).begin) frameTime(vseg(k).begin)],...
        [0 1.2],'color','k','Linestyle','-');
        line([frameTime(vseg(k).end) frameTime(vseg(k).end)],...
        [0 1.2],'color','k','Linestyle','--');
    if k==vsl
        Tx=T2(floor((vseg(k).begin+vseg(k).end)/2));
    end
end
text(2.65,Tx+0.05,'T2');
subplot 413; plot(frameTime,Dpitch,'k'); 
axis([0 max(time) 0 110]);title('基音周期'); ylabel('样点值')
subplot 414; plot(frameTime,Dfreq,'k'); 
axis([0 max(time) 0 250]);title('基音频率'); ylabel('频率/Hz')
xlabel('时间/s'); 

figure(2)
subplot 211; plot(time,x1,'k'); title('原始语音波形');
axis([0 max(time) -1 1.1]); xlabel('时间/s'); ylabel('幅值')
subplot 212; plot(time,output,'k');  title('合成语音波形');
axis([0 max(time) -1 1.1]); xlabel('时间/s'); ylabel('幅值')

figure(3)
out1=out1/max(out1);
subplot 311; plot(time,out1,'k');
title('通过滤波器之前的波形out1')
ylabel('幅值'); ylim([-0.5 1]); xlabel('(a)');
out2=out2/max(out2);
subplot 312; plot(time,out2,'k');
title('通过低通滤波器后的波形out2')
ylabel('幅值'); ylim([-0.5 1]); xlabel('(b)');
subplot 313; plot(time,output,'k');
title('通过高通滤波器后的波形output')
xlabel(['时间/s' 10 '(c)']); ylabel('幅值')

