function x=forback_predictm(y,L,p)
y=y(:);                      % 把y转为列序列
u1=back_predictm(y,L,p);     % 计算后向延拓序列
u2=for_predictm(y,L,p);      % 计算前向延拓序列
x=[u1; y; u2];               % 把前后向预测与y合并成新序列

