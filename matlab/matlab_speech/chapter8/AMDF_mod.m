function period=AMDF_mod(y,fn,vseg,vsl,lmax,lmin)
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
             R0(m) = sum(abs(u(m:wlen)-u(1:wlen-m+1))); % 计算平均幅度差函数
        end 
        [Rmax,Nmax]=max(R0);              % 求取AMDF中最大值和对应位置
        for i = 1 : wlen                  % 进行线性变换
            R(i)=Rmax*(wlen-i)/(wlen-Nmax)-R0(i);
        end
        [Rmax,T]=max(R(lmin:lmax));       % 求出最大值
        T0=T+lmin-1;                      
        period(k+ixb-1)=T0;               % 给出了该帧的基音周期
    end
end


