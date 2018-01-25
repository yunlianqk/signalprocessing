function period=corrbp_test1(y,fn,vseg,vsl,lmax,lmin,ThrC,tst_i1)
pn=size(y,2);
if pn~=fn, y=y'; end                      % 把y转换为每列数据表示一帧语音信号
period=zeros(1,fn);                       % 初始化
if tst_i1>vsl | tst_i1<1
    disp('error: 选择的元音主体号要小于元音主体个数!'); 
%    period=[];
    return;
end
wlen=size(y,1);                           % 帧长
c1=ThrC(1);                               % 设置相邻基音周期间的阈值
i=tst_i1;                                 % i=第tst_i1个元音主体
    ixb=vseg(i).begin;                    % 第i个元音主体开始位置
    ixe=vseg(i).end;                      % 第i个元音主体结束位置
    ixd=ixe-ixb+1;                        % 求取一段有话段帧的帧数
    fprintf('ixd=%4d\n',ixd);             % 显示
    Ptk=zeros(3,ixd);                     % 初始化
    Vtk=zeros(3,ixd);
    Ksl=zeros(1,3);
    figure(50);
    pos = get(gcf,'Position');
    set(gcf,'Position',[pos(1), pos(2)-100,pos(3),pos(4)]);
    for k=1 : ixd                         
        u=y(:,k+ixb-1);                   % 取来一帧信号
        ru=xcorr(u,'coeff');              % 计算自相关函数
        ru=ru(wlen:end);                  % 取正延迟量部分
        subplot 211; plot(u,'k');
        title(['第' num2str(k) '帧波形']);
        xlabel('(a)'); ylabel('幅值');
        subplot 212;
        plot(ru,'k'); grid; xlim([0 150]);
        title(['第' num2str(k) '帧自相关函数R']);
        [Sv,Kv]=findmaxesm3(ru,lmax,lmin);% 获取三个极大值的数值和位置
        lkv=length(Kv);
        Ptk(1:lkv,k)=Kv';                 % 把每帧的三个极大值位置存放在Ptk数组中
        fprintf('%4d   %4d   %4d   %4d\n',k,Kv);
        xlabel(['样点数' 10 '(b)']); ylabel('幅值');
        pause
    end
    
    Kal=Ptk(1,:);                      % 设置Kal
    meanx=mean(Kal);                   % 计算Kal均值
    thegma=std(Kal);                   % 计算Kal标准差
    mt1=meanx+thegma;                  % 设置置信区间上界
    mt2=meanx-thegma;                  % 设置置信区间下界
    fprintf('meanx=%5.4f   thegma=%5.4f   mt1=%5.4f   mt2=%5.4f\n',...
        meanx,thegma,mt1,mt2);
    % 画出元音主体基音初估值曲线
    figure(51);clf
    pos = get(gcf,'Position');
    set(gcf,'Position',[pos(1), pos(2)-100,pos(3),pos(4)-200]);
    plot(1:ixd,Ptk(1,1:ixd),'ko-','linewidth',2); hold on
    plot(1:ixd,Ptk(2,1:ixd),'k*-',1:ixd,Ptk(3,1:ixd),'k+-');
    xlabel('样点数'); ylabel('基音周期');  
    line([1 ixd],[meanx meanx],'color','k','linestyle','--');
    line([1 ixd],[meanx+thegma meanx+thegma],'color','k',...
        'linestyle','-.');
    line([1 ixd],[meanx-thegma meanx-thegma],'color','k',...
        'linestyle','-.');
    period=Kal;
    return    

