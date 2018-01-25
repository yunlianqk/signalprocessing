function period=ACF_corr(y,fn,vseg,vsl,lmax,lmin)
pn=size(y,2);
if pn~=fn, y=y'; end                      % 把y转换为每列数据表示一帧语音信号
wlen=size(y,1);                           % 取得帧长
period=zeros(1,fn);                       % 初始化

for i=1 : vsl                             % 只对有话段数据处理
    ixb=vseg(i).begin;
    ixe=vseg(i).end;
    ixd=ixe-ixb+1;                        % 求取一段有话段的帧数
    for k=1 : ixd                         % 对该段有话段数据处理
        u=y(:,k+ixb-1);                   % 取来一帧数据
        ru= xcorr(u, 'coeff');            % 计算归一化自相关函数
        ru = ru(wlen:end);                % 取延迟量为正值的部分
        [tmax,tloc]=max(ru(lmin:lmax));   % 在Pmin～Pmax范围内寻找最大值
        period(k+ixb-1)=lmin+tloc-1;      % 给出对应最大值的延迟量
    end
end