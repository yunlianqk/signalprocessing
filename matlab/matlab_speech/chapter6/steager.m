function tz=steager(z)
N=length(z);                       % 取得数据长度

for k=2 : N-1                      % 计算Teager能量
    tz(k)=z(k)^2-z(k-1)*z(k+1);
end
tz(1)=2*tz(2)-tz(3);               % 数据外延求出两个端点的值
tz(N)=2*tz(N-1)-tz(N-2);
