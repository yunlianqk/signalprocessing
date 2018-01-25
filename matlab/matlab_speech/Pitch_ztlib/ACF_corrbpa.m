function period=ACF_corrbpa(y,fn,vseg,vsl,lmax,lmin,ThrC)
pn=size(y,2);
if pn~=fn, y=y'; end                      % 把y转换为每列数据表示一帧语音信号
wlen=size(y,1);                           % 帧长
period=zeros(1,fn);                       % 初始化
c1=ThrC(1);                               % 取得阈值
for i=1 : vsl                             % 只对有话段数据处理
    ixb=vseg(i).begin;
    ixe=vseg(i).end;
    ixd=ixe-ixb+1;                        % 求取一段有话段帧的帧数
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
    meanx=mean(Kal);                      % 计算Kal均值
    thegma=std(Kal);                      % 计算Kal标准差
    mt1=meanx+thegma;
    mt2=meanx-thegma;
    if thegma>5, 
        %判断基音候选组中有哪几个在第一次置信区域内
        Ptemp=zeros(size(Ptk));
        Ptemp(1,(Ptk(1,:)<mt1 & Ptk(1,:)>mt2))=1;
        Ptemp(2,(Ptk(2,:)<mt1 & Ptk(2,:)>mt2))=1;
        Ptemp(3,(Ptk(3,:)<mt1 & Ptk(3,:)>mt2))=1;
        % 如果第一组或(和)其他组都有值在第一次置信区内,取数值大的一个值赋于Pam
        Pam=zeros(1,ixd);
        for k=1 : ixd
            if Ptemp(1,k)==1
                Pam(k)=max(Ptk(:,k).*Ptemp(:,k));
            end
        end
        mdex=find(Pam~=0);                    % 在Pam非零的数值中
        meanx=mean(Pam(mdex));                % 计算Pam均值
        thegma=std(Pam(mdex));                % 计算Pam标准差
        if thegma<0.5, thegma=0.5; end
        mt1=meanx+thegma;
        mt2=meanx-thegma;                     % 计算了第二次置信区
        pindex=find(Pam<mt1 & Pam>mt2);       % 寻找在置信区间的数据点
        Pamtmp=zeros(1,ixd);
        Pamtmp(pindex)=Pam(pindex);           % 设置Pamtmp

        if length(pindex)~=ixd
            bpseg=findSegment(pindex);        % 计算置信区间内的数据分段信息
            bpl=length(bpseg);                % 置信区间内的数据分成几段 
            bdb=bpseg(1).begin;               % 置信区间内第一段的开始位置
            if bdb~=1                         % 如果置信区间内第一段开始位置不为1
                Ptb=Pamtmp(bdb);              % 置信区间内第一段开始位置的基音周期
                Ptbp=Pamtmp(bdb+1);
                pdb=ztcont11(Ptk,bdb,Ptb,Ptbp,c1);% 将调用ztcont11函数处理
                Pam(1:bdb-1)=pdb;             % 把处理后的数据放入Pam中
            end
            if bpl>=2
                for k=1 : bpl-1               % 如果有中间数据在置信区间外
                    pdb=bpseg(k).end;
                    pde=bpseg(k+1).begin;
                    Ptb=Pamtmp(pdb);
                    Pte=Pamtmp(pde);
                    pdm=ztcont21(Ptk,pdb,pde,Ptb,Pte,c1);  % 将调用ztcont21函数处理
                    Pam(pdb+1:pde-1)=pdm;     % 把处理后的数据放入Pam中
                end
            end
            bde=bpseg(bpl).end;
            Pte=Pamtmp(bde);
            Pten=Pamtmp(bde-1);
            if bde~=ixd                       % 如果置信区间内最后一段结束位置不为ixd
                pde=ztcont31(Ptk,bde,Pte,Pten,c1);% 将调用ztcont31函数处理
                Pam(bde+1:ixd)=pde;           % 把处理后的数据放入Pam中
            end
        end
        period(ixb:ixe)=Pam;    
    else    
        period(ixb:ixe)=Kal;
    end
end
