function y = casfiltr(b0,B,A,x);
%  IIR 和 FIR滤波器的级联型的实现
% -----------------------------------------------
%  y = casfiltr(b0,B,A,x);
%  y = 输出序列
% b0 = 级联型的增益系数
%  B = 包含各bk的K乘3维实系数矩阵
%  A = 包含各ak的K乘3维实系数矩阵
%  x = 输入序列
%
[K,L] = size(B);
N = length(x);
w = zeros(K+1,N);
w(1,:) = x;
for i = 1:1:K
        w(i+1,:) = filter(B(i,:),A(i,:),w(i,:));
end
y = b0*w(K+1,:);

