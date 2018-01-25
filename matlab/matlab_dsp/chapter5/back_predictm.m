function y=back_predictm(x,M,p)
x=x(:);                 % 把x转为列序列
ar1=arburg(x,p);        % 计算自回归求得ar
yy=zeros(M,1);          % 初始化
yy=[yy; x(1:p)];        % 准备后向预测的序列
for l=1 : M             % 朝后预测得M个数
    for k=1 : p         % 按式(4-6-27)累加
        yy(M+1-l)=yy(M+1-l)-yy(M+1-l+k)*ar1(k+1);
    end
    yy(M+1-l)=real(yy(M+1-l));
end
y=yy(1:M);              % 得后向预测的序列

