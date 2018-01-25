function X=dtft_dkm(w,dk,nmsign)
w=w(:)';           % 使w为一个行序列
N=length(w);       % w的长度
m=dk/N;            % 按式(6-4-38)
n1=0:N-1;          % n序列
p=n1'*2*pi*m;      % 按式(6-4-38) 
ewn=exp(-1j*p);    % 指数序列
X=w*ewn;           % DTFT
if nmsign==1
    X=X/N;         % 归一化
end