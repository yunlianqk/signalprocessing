function [Pm,vsegch,vsegchlong]=Ext_corrshtpm(y,sign,TT1,XL,ixb,lmax,lmin,ThrC)
wlen=size(y,1);                           % 取得帧长
c1=ThrC(1); c2=ThrC(2);                   % 取得阈值

for k=1 : XL                              % 循环XL次往后部延伸区间提取基音周期初估值
    j=ixb+sign*k;                         % 修正帧的编号
    u=y(:,j);                             % 取来一帧信号
    ru=xcorr(u,'coeff');                  % 计算自相关函数
    ru=ru(wlen:end);                      % 取正延迟量部分
    [Sv,Kv]=findmaxesm3(ru,lmax,lmin);    % 获取三个极大值的数值和位置
    Ptk(:,k)=Kv';
end
% 按最短矩离寻找基音周期
Pkint=zeros(1,XL);
Ts=TT1;                                   % 初始设置Ts
Emp=0;                                    % 初始设置Emp
for k=1 : XL                              % 循环
    Tp=Ptk(:,k);                          % Ts与本帧的三个峰值中寻找差值最小
    Tz=abs(Ts-Tp);
    [tv,tl]=min(Tz);                      % 最小的位置在tl,数值为tv
    if k==1                               % 是否第1帧
        if tv<=c1, Pkint(k)=Tp(tl); Ts=Tp(tl);%是,tv小于c1,设置Pkint和Ts
        else Pkint(k)=0; Emp=1; end       % tv大于c1,Pkint为0,Emp=1,Ts不变
    else                                  % 不是第1帧
        if Pkint(k-1)==0                  % 上一帧Pkint是否为0
            if tv<c2, Pkint(k)=Tp(tl); Ts=Tp(tl);%是,tv小于c2,设置Pkint和Ts
            else Pkint(k)=0; Emp=1; end   % tv大于c2,Pkint为0,Emp=1,Ts不变
        else                              % 上一帧Pkint不为0
            if tv<=c1, Pkint(k)=Tp(tl); Ts=Tp(tl);%tv小于c1,设置Pkint和Ts
            else Pkint(k)=0; Emp=1; end   % tv大于c1,Pkint为0,Emp=1,Ts不变
        end
    end
end
% 内插处理
Pm=Pkint;
vsegch=0;
vsegchlong=0;
if Emp==1
    pindexz=find(Pkint==0);             % 寻找零值区间的信息
    pzseg=findSegment(pindexz);
    pzl=length(pzseg);                  % 零值区间有几处
    for k1=1 : pzl                      % 取一段零值区间
        zx1=pzseg(k1).begin;            % 零值区间开始位置
        zx2=pzseg(k1).end;              % 零值区间结束位置
        zxl=pzseg(k1).duration;         % 零值区间长度
        if zx1~=1 & zx2~=XL             % 零值点处于延伸区的中部
            deltazx=(Pm(zx2+1)-Pm(zx1-1))/(zxl+1);
            for k2=1 : zxl              % 线性内插
                Pm(zx1+k2-1)=Pm(zx1-1)+k2*deltazx;
            end
        elseif zx1==1 & zx2~=XL         % 零值点发生在延伸区头部
            deltazx=(Pm(zx2+1)-TT1)/(zxl+1);
            for k2=1:zxl                % 利用TT1线性内插
                Pm(zx1+k2-1)=TT1+k2*deltazx;
            end
        else
            vsegch=1;
            vsegchlong=zxl;
        end
    end
end

