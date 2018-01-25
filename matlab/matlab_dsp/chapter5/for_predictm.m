function y=for_predictm(x,N,p)
x=x(:);                 % 把x转为列序列
M=length(x);            % x长度
L=M-p;                  % 设置前向预测位置
ar=arburg(x,p);         % 计算自回归求得ar
xx=x(L+1:L+p);          % 准备前向预测的序列
for i=1:N               % 朝前预测得N个数
    xx(p+i)=0;          % 初始化
    for k=1:p           % 按式(4-6-3)累加
        xx(p+i)=xx(p+i)-xx(p+i-k)*ar(k+1);
    end
end
y=xx(p+1:p+N);          % 得前向预测的序列


