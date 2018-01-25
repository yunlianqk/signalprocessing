function pdb=ztcont11(Ptk,bdb,Ptb,Ptbp,c1)

kl=bdb-1;                           % 取得在置信区内第一段外的第一个位置
T0=Ptb;                             % 置信区内第一段第一个数据点的基音周期值
T1=Ptbp;                            % 置信区内第一段第二个数据点的基音周期值
pdb=zeros(1,kl);                    % 初始化pdb
for k=kl:-1:1                       % 循环
    [mv,ml]=min(abs(T0-Ptk(:,k)));  % 按最短距离寻找最小差值
    pdb(k)=Ptk(ml,k);               % 找到ml
    TT=Ptk(ml,k);
    if abs(T0-TT)>c1                % 如果大于阈值
        TT=2*T0-T1;                 % 向前外推延伸
        pdb(k)=TT;
    end
    T1=T0;
    T0=TT;
end

    

