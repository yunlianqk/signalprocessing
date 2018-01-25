function period=ACFAMDF_corr(y,fn,vseg,vsl,lmax,lmin)
pn=size(y,2);
if pn~=fn, y=y'; end                      % 把y转换为每列数据表示一帧语音信号
period=zeros(1,fn);                       % 初始化
wlen=size(y,1);                           % 取得帧长
Acm=zeros(1,lmax);
for i=1 : vsl                             % 只对有话段数据处理
    ixb=vseg(i).begin;
    ixe=vseg(i).end;
    ixd=ixe-ixb+1;                        % 求取一段有话段的帧数
    for k=1 : ixd                         % 对该段有话段数据处理
        u=y(:,k+ixb-1);                   % 取来一帧数据
        ru= xcorr(u, 'coeff');            % 计算归一化自相关函数
        ru = ru(wlen:end);                % 取延迟量为正值的部分
        for m = 1:wlen
             R(m) = sum(abs(u(m:wlen)-u(1:wlen-m+1))); % 计算平均幅度差函数(AMDF)
        end 
        R=R(1:length(ru));                % 取与ru等长 
        Rindex=find(R~=0);       
        Acm(Rindex)=ru(Rindex)'./R(Rindex);% 计算ACF/AMDF
        [tmax,tloc]=max(Acm(lmin:lmax));  % 在Pmin～Pmax范围内寻找最大值
        period(k+ixb-1)=lmin+tloc-1;      % 给出对应最大值的延迟量
        
    end
end


