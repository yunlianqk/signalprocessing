function period=Wavelet_corrm1(y,fn,vseg,vsl,lmax,lmin)
pn=size(y,2);
if pn~=fn, y=y'; end                      % 把y转换为每列数据表示一帧语音信号
period=zeros(1,fn);                       % 初始化

for i=1 : vsl                             % 只对有话段数据处理
    ixb=vseg(i).begin;
    ixe=vseg(i).end;
    ixd=ixe-ixb+1;                        % 求取一段有话段帧的帧数
    for k=1 : ixd                         % 对该段有话段数据处理
        u=y(:,k+ixb-1);                   % 取来一帧数据
        [ca1,cd1] = dwt(u,'db4');         % 用dwt做小波变换 
        a1 = upcoef('a',ca1,'db4',1);     % 用低频系数重构信号
        ru=xcorr(a1, 'coeff');            % 计算归一化自相关函数
        aL=length(a1);
        ru=ru(aL:end);                    % 取延迟量为正值的部分
        [tmax,tloc]=max(ru(lmin:lmax));   % 在lmin至lmax范围内寻找最大值 
        period(k+ixb-1)=lmin+tloc-1;      % 给出对应最大值的延迟量
    end
end