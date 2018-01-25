function period=ACF_threelevel(y,fn,vseg,vsl,lmax,lmin)
pn=size(y,2);
if pn~=fn, y=y'; end                      % 把y转换为每列数据表示一帧语音信号
wlen=size(y,1);                           % 取得帧长
period=zeros(1,fn);                       % 初始化

for i=1:vsl                               % 只对有话段数据处理
    ixb=vseg(i).begin;
    ixe=vseg(i).end;
    ixd=ixe-ixb+1;                        % 求取一段有话段的帧数
    for k=1 : ixd                         % 对该段有话段数据处理
        u=y(:,k+ixb-1);                   % 取来一帧数据
        px1=u(1:100);                     % 取前部100个样点
        px2=u(wlen-99:wlen);              % 取后部100个样点
        clm=min(max(px1),max(px2));       % 找两者最大值中较小一个
        cl=clm*0.68;                      % 乘0.68得三电平中心削波系数
        three=zeros(1,wlen);              % 初始化
        for j=1:wlen;                     % 进行中心削波处理和三电平削波
            if u(j)>cl;
                u(j)=u(j)-cl;
                three(j)=1;
            elseif   u(j)<-cl;
                u(j)=u(j)+cl;
                three(j)=-1; 
            else
                u(j)=0;
                three(j)=0;
            end
        end
% 计算互相关函数法求基音周期   
        r=xcorr(three,u,'coeff');         % 计算归一化互相关函数
        r=r(wlen:end);                    % 取延迟量为正值的部分
        [v,b]=max(r(lmin:lmax));          % 在Pmin～Pmax范围内寻找最大值
        period(k+ixb-1)=b+lmin-1;         % 给出对应最大值的延迟量
    end
end
