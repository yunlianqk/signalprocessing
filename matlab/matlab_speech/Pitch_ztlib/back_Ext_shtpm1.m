function [Ext_T,voiceseg]=back_Ext_shtpm1(y,fn,voiceseg,Bth,ix1,...
        ixl1,T1,m,lmax,lmin,ThrC)
if nargin<11, ThrC(1)=10; ThrC(2)=15; end
if size(y,2)~=fn, y=y'; end               % 把y转换为每列数据表示一帧语音信号
wlen=size(y,1);                           % 取得帧长
TT1=round(T1(ix1));                       % 元音主体第一个点的基音周期
XL=ixl1;
sign=-1;                                  % 前向延伸区间检测
ixb=ix1;
[Pm,vsegch,vsegchlong]=Ext_corrshtpm(y,sign,TT1,XL,ixb,lmax,lmin,ThrC);

if vsegch==1                              % 如果vsegch为1,要对voiceseg进行修正 
    j=Bth(m);
    if m~=1
        j1=Bth(m-1);
% 判断本元音主体和上一个元音主体是否在同一个有话段内
        if j~=j1                         % 不在同一个有话段内,对voiceseg进行修正
            voiceseg(j).begin=voiceseg(j).begin+vsegchlong;
            voiceseg(j).duration=voiceseg(j).duration-vsegchlong;
        end

    else                                  % 是第一个元音主体,对voiceseg进行修正
        voiceseg(j).begin=voiceseg(j).begin+vsegchlong;
        voiceseg(j).duration=voiceseg(j).duration-vsegchlong;
    end
end

Pm=Pm(:)';                                % Pm成行数组
Pmup=fliplr(Pm);                          % 把Pm倒序
Ext_T=Pmup;                               % 赋值输出 







