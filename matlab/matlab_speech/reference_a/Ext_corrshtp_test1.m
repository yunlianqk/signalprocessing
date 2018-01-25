function [Pm,vsegch,vsegchlong]=Ext_corrshtp_test1(y,sign,TT1,XL,ixb,...
    lmax,lmin,ThrC)
wlen=size(y,1);
Emp=0;                                    % 初始设置Emp
c1=ThrC(1); c2=ThrC(2);
figure(50);
    pos = get(gcf,'Position');
    set(gcf,'Position',[pos(1), pos(2)-100,pos(3),pos(4)]);
% 循环XL次前向或后向延伸区间提取基音周期初估值
for k=1 : XL                              
    j=ixb+sign*k;                         % 修正帧的编号
    u=y(:,j);                             % 取来一帧信号
    ru=xcorr(u,'coeff');                  % 计算自相关函数
    ru=ru(wlen:end);                      % 取正延迟量部分
    figure(50)
    subplot 211; plot(u,'k');
    title(['第' num2str(k) '帧波形']);
     xlabel('(a)'); ylabel('幅值');
    subplot 212;
    plot(ru,'k'); grid; xlim([0 150]);
    title(['第' num2str(k) '帧自相关函数R']);
    xlabel(['样点数' 10 '(b)']); ylabel('幅值');
    [Sv,Kv]=findmaxesm3(ru,lmax,lmin);    % 获取三个极大值的数值和位置
    Ptk(:,k)=Kv';
    fprintf('%4d   %4d   %4d   %4d\n',k,Kv);
    pause
end

figure(51)
    pos = get(gcf,'Position');
    set(gcf,'Position',[pos(1), pos(2)-100,pos(3),(pos(4)-200)]);
    plot(1:XL,Ptk(1,1:XL),'ko-',1:XL,Ptk(2,1:XL),'k*-',1:XL,...
        Ptk(3,1:XL),'k+-'); grid;
    xlabel('样点数'); ylabel('基音周期')
    title('延伸区间基音周期候选数组图');
    Pm=Ptk(1,:);
    vsegch=0; vsegchlong=0;

