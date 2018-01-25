function pde=ztcont31(Ptk,bde,Pte,Pten,c1)

fn=size(Ptk,2);                     % 取来Ptk有多少列
kl=fn-bde;                          % 取得在置信区外有多少个数据点
T0=Pte;                             % 置信区内最后一段最后一个数据点的基音周期值
T1=Pten;                            % 置信区内最后一段最后第二个数据点的基音周期值
pde=zeros(1,kl);                    % 初始化pde
for k=1:kl                          % 循环
    j=k+bde;
    [mv,ml]=min(abs(T0-Ptk(:,j)));  % 按最短距离寻找最小差值
    pde(k)=Ptk(ml,j);               % 找到ml;
    TT=Ptk(ml,j);
    if abs(T0-TT)>c1                % 如果大于阈值
        TT=2*T0-T1;                 % 向后外推延伸
        pde(k)=TT;
    end
    T1=T0;
    T0=TT;
end
    
    

