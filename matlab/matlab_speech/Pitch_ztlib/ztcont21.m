function pdm=ztcont21(Ptk,bdb,bde,Ptb,Pte,c1)

kl=bde-bdb-1;                       % 在置信区间外有多少个数据点
T0=Ptb;                             % 在置信区间内前一段的最后一个点的基音周期
pdm=zeros(1,kl);
Jmp=0; emp=0;
for k=1 : kl                        % 循环
    j=k+bdb;
    [mv,ml]=min(abs(T0-Ptk(:,j)));  % 按最短距离寻找最小差值
    TT=Ptk(ml,j);
    if abs(T0-TT)>c1                % 如果大于阈值
        emp=1;                      % 参数设置
        Jmp=k;
        break                       % 终止本循环
    end
    pdm(k)=Ptk(ml,j);
    T0=Ptk(ml,j);
end

if emp==1                           % 由于大于阈值需内插
    zxl=kl-Jmp+1;
    deltazx=(Pte-T0)/(zxl+1);
    for k2=1 : zxl                  % 线性内插
        pdm(k2)=T0+k2*deltazx;
    end
end

    
    

