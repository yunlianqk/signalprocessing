function [Sv,Kv]=findmaxesm3(ru,lmax,lmin)
Sv=zeros(1,3); Kv=zeros(1,3);          % 初始化
if isnan(ru),  return; end 
[K,V]=findpeaks(ru(lmin:lmax),[],lmin);% 在ru的Pmin～Pmax中寻找峰值
K=K+lmin-1;                            % 修正峰值位置
[V,ind]=sort(V','descend');            % 峰值的幅值按幅值大小递减次序排列
K=K(ind);                              % 峰值对应位置的排列与V的排列相对应
vindex=find(V>0.2);                    % 剔除峰值幅值小于0.2的点
V=V(vindex); K=K(vindex);
vl=length(V);                          % 峰值个数
Sv(1:min(vl,3))=V(1:min(vl,3));        % 对于峰值个数最多只取前三个赋于Sv和Kv
Kv(1:min(vl,3))=K(1:min(vl,3));

