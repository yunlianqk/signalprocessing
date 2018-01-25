function [Ext_T,voiceseg]=fore_Ext_shtpm1(y,fn,voiceseg,Bth,ix2,...
        ixl2,vsl,T1,m,lmax,lmin,ThrC)
if nargin<12, ThrC(1)=10; ThrC(2)=15; end
if size(y,2)~=fn, y=y'; end               % 把y转换为每列数据表示一帧语音信号
wlen=size(y,1);                           % 取得帧长
XL=ixl2;
sign=1;                                   % 后向延伸区间检测
TT1=round(T1(ix2));                       % 元音主体最后一个点的基音周期
ixb=ix2;
[Ext_T,vsegch,vsegchlong]=Ext_corrshtpm(y,sign,TT1,XL,ixb,lmax,lmin,ThrC);

if vsegch==1                              % 如果vsegch为1,要对voiceseg进行修正
    j=Bth(m);                            
% 判断本元音主体和下一个元音主体是否在同一个有话段内
    if m~=vsl
        j1=Bth(m+1); 
        if j~=j1                         % 不在同一个有话段内,对voiceseg进行修正
            voiceseg(j).end=voiceseg(j).end-vsegchlong;
            voiceseg(j).duration=voiceseg(j).duration-vsegchlong;
        end

    else                                  % 是最后一个元音主体,对voiceseg进行修正
        voiceseg(j).end=voiceseg(j).end-vsegchlong;
        voiceseg(j).duration=voiceseg(j).duration-vsegchlong;
    end
end







