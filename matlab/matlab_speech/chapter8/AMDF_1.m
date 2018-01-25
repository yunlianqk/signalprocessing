function period=AMDF_1(y,fn,vseg,vsl,lmax,lmin)
pn=size(y,2);
if pn~=fn, y=y'; end                      % 把y转换为每列数据表示一帧语音信号
period=zeros(1,fn);                       % 初始化
wlen=size(y,1);                           % 取得帧长
for i=1 : vsl                             % 只对有话段数据处理
    ixb=vseg(i).begin;
    ixe=vseg(i).end;
    ixd=ixe-ixb+1;                        % 求取一段有话段的帧数
    for k=1 : ixd                         % 对该段有话段数据处理
        u=y(:,k+ixb-1);                   % 取来一帧数据
        for m = 1:wlen
             R(m) = sum(abs(u(m:wlen)-u(1:wlen-m+1))); % 计算平均幅度差函数(AMDF)
        end 
        [Rmax,Rloc]=max(R(1:lmin));       % 求出最大值
        Rth=0.6*Rmax;                     % 设置一个阈值
        Rm=find(R(lmin:lmax)<=Rth);       % 在Pmin～Pmax区间寻找出小于该阈值的区间
        if isempty(Rm)                    % 如果找不到,T0置为0
            T0=0;
        else
            m11=Rm(1);                    % 如果有小于阈值的区间
            m22=lmax;
            [Amin,T]=min(R(m11:m22));     % 寻找最小值的谷值点
            if isempty(T)
                T0=0;
            else
                T0=T+m11-1;               % 把最小谷值点的位置赋于T0
            end
            period(k+ixb-1)=T0;           % 给出了该帧的基音周期
        end
    end
end


