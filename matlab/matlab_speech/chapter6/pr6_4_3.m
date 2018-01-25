%
% pr6_4_3 
clear all; clc; close all;

run Set_I                               % 基本设置
run PART_I                              % 读入数据，分帧等准备

% BARK子带参数表
Fk=[50 20 100; 150 100 200; 250 200 300; 350 300 400; 450 400 510; 570 510 630; 700 630 770;...
    840 770 920; 1000 920 1080; 1170 1080 1270; 1370 1270 1480; 1600 1480 1720; 1850 1720 2000;...
    2150 2000 2320; 2500 2320 2700; 2900 2700 3150; 3400 3150 3700; 4000 3700 4400;...
    4800 4400 5300; 5800 5300 6400; 7000 6400 7700; 8500 7700 9500; 10500 9500 12000;... 
    13500 12000 15500; 18775 15500 22050];

% 插值
fs2=fix(fs/2); 
y=y';
for i=1:fn
    sourfft(i,:)=fft(y(i,:),wlen);                    % FFT变换                    
    sourfft1(i,:)=abs(sourfft(i,1:wlen/2));           % 取正频率幅值
    sourre(i,:)=resample(sourfft1(i,:),fs2,wlen/2);   % 谱线内插
end
% 计算BARK滤波器个数
for k=1 : 25
    if Fk(k,3)>fs2
        break
    end
end
num=k-1;

for i=1 : fn
    Sr=sourre(i,:);                     % 取一帧谱值
    for k=1 : num   
        m1=Fk(k,2); m2=Fk(k,3);         % 求出BARK滤波器的上下截止频率
        Srt=Sr(m1:m2);                  % 取来相应的谱线
        Dst(k)=var(Srt);                % 求笫k个BARK滤波器中的方差值
    end
    Dvar(i)=mean(Dst);                  % 求各个BARK滤波器中方差值的平均值
end
Dvarm=multimidfilter(Dvar,10);          % 平滑处理
dth=mean(Dvarm(1:(NIS)));               % 阈值计算
T1=1.5*dth;
T2=3*dth;
[voiceseg,vsl,SF,NF]=vad_param1D(Dvarm,T1,T2);    % BARK子带的频带方差双门限的端点检测
% 作图
subplot 311; plot(time,x,'k');
title('纯语音波形');
ylabel('幅值'); axis([0 max(time) -1 1]);
subplot 312; plot(time,signal,'k');
title('加噪语音波形(信噪比10dB)');
ylabel('幅值'); axis([0 max(time) -1 1]);
subplot 313; plot(frameTime,Dvar,'k');
title('短时BARK子带分离的频带方差值'); axis([0 max(time) 0 1.2*max(Dvar)]);
xlabel('时间/s'); ylabel('幅值'); 
line([0,frameTime(fn)], [T1 T1], 'color','k','LineStyle','--');
line([0,frameTime(fn)], [T2 T2], 'color','k','LineStyle','-');
for k=1 : vsl                           % 标出语音端点
    nx1=voiceseg(k).begin; nx2=voiceseg(k).end;
    fprintf('%4d   %4d   %4d\n',k,nx1,nx2);
    subplot 311; 
    line([frameTime(nx1) frameTime(nx1)],[-1 1],'color','k','LineStyle','-');
    line([frameTime(nx2) frameTime(nx2)],[-1 1],'color','k','LineStyle','--');
    subplot 313; 
    line([frameTime(nx1) frameTime(nx1)],[0 1.2*max(Dvar)],'color','k','LineStyle','-');
    line([frameTime(nx2) frameTime(nx2)],[0 1.2*max(Dvar)],'color','k','LineStyle','--');
end
