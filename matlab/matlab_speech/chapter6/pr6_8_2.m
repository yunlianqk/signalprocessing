%
% pr6_8_2 
clear all; clc; close all;

run Set_I                               % 基本设置
run PART_I                              % 读入数据，分帧等准备

imf=emd(signal);                        % EMD分解
M=size(imf,1);                          % 取得分解后IMF的阶数
u=zeros(1,N);
h=waitbar(0,'Running...');              % 设置运行程序进度条图,初始化
set(h,'name','端点检测 - 0%');           % 设置本图的名称“端点检测”
for k=3 : M                             % 丢弃前2阶IMF重构语音信号
    u=u+imf(k,:);
end
z=enframe(u,wnd,inc)';                  % 重构语音信号的分帧

for k=1 : fn
    v=z(:,k);                           % 取来一帧
    imf=emd(v);                         % EMD分解
    L=size(imf,1);                      % 取得分解后IMF的阶数L
    Etg=zeros(1,wlen);
    for i=1 : L                         % 计算每阶IMF的平均Teager能量
        Etg=Etg+steager(imf(i,:));
    end
    Tg(k,:)=Etg;
    Tgf(k)=mean(Etg);                   % 计算本帧的平均Teager能量
    waitbar(k/fn,h)                     % 显示运行的百分比,用红条表示
% 显示本图的名称"端点检测",并显示运行的百分比数,用数字表示
    set(h,'name',['端点检测 - ' sprintf('%2.1f',k/fn*100) '%'])
end
close(h)                                % 关闭程序进度条
Zcr=zc2(y,fn);                          % 计算过零率
Tgfm=multimidfilter(Tgf,10);            % 平滑处理
Zcrm=multimidfilter(Zcr,10);            % 平滑处理
Mtg=max(Tgfm);                          % 计算阈值
Tmth=mean(Tgfm(1:NIS));
Zcrth=mean(Zcrm(1:NIS));
T1=1.5*Tmth;
T2=3*Tmth;
T3=0.9*Zcrth;
T4=0.8*Zcrth;
% 双参数双门限的端点检测
[voiceseg,vsl,SF,NF]=vad_param2D_revr(Tgfm,Zcrm,T1,T2,T3,T4);
% 作图
pos = get(gcf,'Position');
set(gcf,'Position',[pos(1), pos(2)-200,pos(3),pos(4)+150]) 
subplot 511; plot(time,x,'k');
title('纯语音波形');
ylabel('幅值'); axis([0 max(time) -1 1]);
subplot 512; plot(time,signal,'k');
title(['加噪语音波形 信噪比=' num2str(SNR) 'dB']);
ylabel('幅值'); axis([0 max(time) -1 1]);
subplot 513; plot(time,u,'k'); ylim([-1 1]);
title('EMD后重构的语音波形');
ylabel('幅值'); axis([0 max(time) -1 1]);
subplot 514; plot(frameTime,Tgfm,'k'); 
title('短时EMD分解后Teager能量平均值'); ylim([0 1.2*Mtg]);
ylabel('T能量平均值'); 
line([0 max(time)], [T1 T1],'color','k','lineStyle','--');
line([0 max(time)], [T2 T2], 'color','k','lineStyle','-');
subplot 515; plot(frameTime,Zcrm,'k');
title('短时过零率值'); ylim([0 1.2*max(Zcrm)]);
xlabel('时间/s'); ylabel('过零率值'); 
line([0 max(time)], [T3 T3], 'color','k','lineStyle','--');
line([0 max(time)], [T4 T4], 'color','k','lineStyle','-');

for k=1 : vsl
    nx1=voiceseg(k).begin; nx2=voiceseg(k).end;
    fprintf('%4d   %4d   %4d\n',k,nx1,nx2);
    figure(1); subplot 511; 
    line([frameTime(nx1) frameTime(nx1)],[-1 1],'color','k','lineStyle','-');
    line([frameTime(nx2) frameTime(nx2)],[-1 1],'color','k','lineStyle','--');
    subplot 514; 
    line([frameTime(nx1) frameTime(nx1)],[0 1.2*Mtg],'color','k','lineStyle','-');
    line([frameTime(nx2) frameTime(nx2)],[0 1.2*Mtg],'color','k','lineStyle','--');
    subplot 515;
    line([frameTime(nx1) frameTime(nx1)],[0 1.2*max(Zcrm)],'color','k','lineStyle','-');
    line([frameTime(nx2) frameTime(nx2)],[0 1.2*max(Zcrm)],'color','k','lineStyle','--');
end


