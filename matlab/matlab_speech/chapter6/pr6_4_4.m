%
% pr6_4_4 
clear all; clc; close all;

run Set_I                                % 基本设置
run PART_I                               % 读入数据，分帧等准备
h=waitbar(0,'Running...');               % 设置运行程序进度条图,初始化
set(h,'name','端点检测 - 0%');            % 设置本图的名称"端点检测"
for i=1 : fn
    u=y(:,i);                            % 取第i帧数据
    v=wavlet_barkms(u,'db2',fs);         % 利用小波包分解获取17个BARK子带数据
    num=size(v,1);
    for k=1 : num   
        Srt=v(k,:);                      % 取得第k个BARK子带中的数据
        Dst(k)=var(Srt);                 % 求第k个BARK子带中的方差值
    end
    Dvar(i)=mean(Dst);                   % 对17个BARK子带计算方差平均
    waitbar(i/fn,h)                      % 显示运行的百分比,用红条表示
% 显示本图的名称"端点检测",并显示运行的百分比数,用数字表示
    set(h,'name',['端点检测 - ' sprintf('%2.1f',i/fn*100) '%'])
end
close(h)                                % 关闭程序进度条图
Dvarm=multimidfilter(Dvar,10);          % 平滑处理
Dvarm=Dvarm/max(Dvarm);                 % 幅值归一化

dth=mean(Dvarm(1:(NIS)));               % 阈值计算
T1=1.5*dth;
T2=2.5*dth;
[voiceseg,vsl,SF,NF]=vad_param1D(Dvarm,T1,T2);% 小波包BARK子带时域方差双门限的端点检测
% 作图
subplot 311; plot(time,x,'k');
title('纯语音波形');
ylabel('幅值'); axis([0 max(time) -1 1]);
subplot 312; plot(time,signal,'k');
title('加噪语音波形(信噪比10dB)');
ylabel('幅值'); axis([0 max(time) -1 1]);
subplot 313; plot(frameTime,Dvarm,'k');
title('小波包短时BARK子带方差值'); axis([0 max(time) 0 1.2*max(Dvarm)]);
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
    line([frameTime(nx1) frameTime(nx1)],[0 1.2*max(Dvarm)],'color','k','LineStyle','-');
    line([frameTime(nx2) frameTime(nx2)],[0 1.2*max(Dvarm)],'color','k','LineStyle','--');
end
