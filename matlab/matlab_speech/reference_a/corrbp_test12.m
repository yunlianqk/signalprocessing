function period=corrbp_test12(y,fn,vseg,vsl,lmax,lmin,ThrC,tst_i1)
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
    for k=1 : ixd                         
        u=y(:,k+ixb-1);                   % 取来一帧信号
        ru=xcorr(u,'coeff');              % 计算自相关函数
        ru=ru(wlen:end);                  % 取正延迟量部分
        [Sv,Kv]=findmaxesm3(ru,lmax,lmin);% 获取三个极大值的数值和位置
        lkv=length(Kv);
        Ptk(1:lkv,k)=Kv';                 % 把每帧三个极大值位置存放在Ptk数组中
    end
    Kal=Ptk(1,:);
    figure(51);clf
    pos = get(gcf,'Position');
    set(gcf,'Position',[pos(1), pos(2)-100,pos(3),(pos(4)-200)]);
    plot(1:ixd,Ptk(1,1:ixd),'ko-',1:ixd,Ptk(2,1:ixd),'k*-',...
        1:ixd,Ptk(3,1:ixd),'k+-');
    xlabel('样点数'); ylabel('基音周期'); hold on
    % 计算第一次置信区间
    meanx=mean(Kal);                      % 计算Kal均值
    thegma=std(Kal);                      % 计算Kal标准差
    mt1=meanx+thegma;                     % 设置置信区间上界
    mt2=meanx-thegma;                     % 设置置信区间下界
    fprintf('meanx=%5.4f   thegma=%5.4f   mt1=%5.4f   mt2=%5.4f\n',...
        meanx,thegma,mt1,mt2);
    line([1 ixd],[meanx meanx],'color','k','linestyle','--');
    line([1 ixd],[meanx+thegma meanx+thegma],'color','k','linestyle','-.');
    line([1 ixd],[meanx-thegma meanx-thegma],'color','k','linestyle','-.');
    if thegma>5, 
        
        Ptemp=zeros(size(Ptk));
        Ptemp(1,(Ptk(1,:)<mt1 & Ptk(1,:)>mt2))=1;% 检查各组数据有否在置信区间
        Ptemp(2,(Ptk(2,:)<mt1 & Ptk(2,:)>mt2))=1;
        Ptemp(3,(Ptk(3,:)<mt1 & Ptk(3,:)>mt2))=1;
    
        Pam=zeros(1,ixd);                 % 在Pam中存放置信区间内大的数值
        for k=1 : ixd
            if Ptemp(1,k)==1
                Pam(k)=max(Ptk(:,k).*Ptemp(:,k));
            end
        end
        % 计算第二次置信区间
        mdex=find(Pam~=0);
        meanx=mean(Pam(mdex));                % 计算Pam均值
        thegma=std(Pam(mdex));                % 计算Pam标准差
        if thegma<0.5, thegma=0.5; end
        mt1=meanx+thegma;                     % 设置置信区间上界
        mt2=meanx-thegma;                     % 设置置信区间下界
        pindex=find(Pam<mt1 & Pam>mt2);       % 寻找在置信区间的数据点
        fprintf('meanx2=%5.4f   thegma=%5.4f   mt1=%5.4f   mt2=%5.4f\n',...
            meanx,thegma,mt1,mt2);
        line([1 ixd],[meanx meanx],'color',[.6 .6 .6],'linestyle','--');
        line([1 ixd],[meanx+thegma meanx+thegma],'color',[.6 .6 .6],...
            'linestyle','-.');
        line([1 ixd],[meanx-thegma meanx-thegma],'color',[.6 .6 .6],...
            'linestyle','-.');
        Pamtmp=zeros(1,ixd);
        Pamtmp(pindex)=Pam(pindex);           % 设置Pamtmp
        line([1:ixd],[Pamtmp(1:ixd)],'color',[.6 .6 .6],'linewidth',3);

        if length(pindex)~=ixd
            bpseg=findSegment(pindex);        % 计算置信区间内的数据分段信息
            bpl=length(bpseg);                % 置信区间内的数据分成几段 
            bdb=bpseg(1).begin;               % 置信区间内第一段的开始位置
            if bdb~=1                         % 如果置信区间内第一段开始位置不为1
                Ptb=Pamtmp(bdb);              % 置信区间内第一段开始位置的基音周期
                Ptbp=Pamtmp(bdb+1);
                pdb=ztcont11(Ptk,bdb,Ptb,Ptbp,c1);% 将调用ztcont11
                Pam(1:bdb-1)=pdb;             % 把处理后的数据放入Pam中
            end
            if bpl>=2
                for k=1 : bpl-1               % 如果在Kal中间有数据在置信区间外
                    pdb=bpseg(k).end;
                    pde=bpseg(k+1).begin;
                    Ptb=Pamtmp(pdb);
                    Pte=Pamtmp(pde);
                    pdm=ztcont21(Ptk,pdb,pde,Ptb,Pte,c1);% 调用ztcont21
                    Pam(pdb+1:pde-1)=pdm;     % 把处理后的数据放入Pam中
                end
            end
            bde=bpseg(bpl).end;
            Pte=Pamtmp(bde);
            Pten=Pamtmp(bde-1);
            if bde~=ixd                 % 如果置信区间内最后一段的开始位置不为ixd
                pde=ztcont31(Ptk,bde,Pte,Pten,c1);% 将调用ztcont31
                Pam(bde+1:ixd)=pde;           % 把处理后的数据放入Pam中
            end
        end
        period(ixb:ixe)=Pam;    
    else    
        period(ixb:ixe)=Kal;
    end
    plot(1:ixd,period(ixb:ixe),'k^-','linewidth',2);
    title('元音主体基音周期的初估值');
    
    
