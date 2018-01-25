function zcr=zc2(y,fn)
if size(y,2)~=fn, y=y'; end
wlen=size(y,1);                            % 设置帧长
zcr=zeros(1,fn);                           % 初始化
delta=0.01;                                % 设置一个很小的阈值
for i=1:fn
    yn=y(:,i);                             % 取来一帧
    for k=1 : wlen                         % 中心截幅处理
        if yn(k)>=delta
            ym(k)=yn(k)-delta;
        elseif yn(k)<-delta
            ym(k)=yn(k)+delta;
        else
            ym(k)=0;
        end
    end
    zcr(i)=sum(ym(1:end-1).*ym(2:end)<0);  % 取得处理后的一帧数据寻找过零率
end