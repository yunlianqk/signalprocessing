function y=conv_ovlsav1(x,h,L)
% 用重叠存储法计算卷积
x=x(:)';
Lenx = length (x);          % 计算x长
N=length(h);                % 计算h长 
N1=N-1;
M=L-N1;
H=fft(h, L);                % 求h的FFT为H
x=[zeros(1,N1), x, zeros(1, L-1)]; % 前后补零
K = floor((Lenx+ N1-1)/M);  % 求分帧个数
Y=zeros(K+1, L);            % 初始化
for k=0 : K                 % 对每帧处理
   Xk=fft(x(k*M+1:k*M+L));  % 做 FFT
   Y(k+1,:)=real(ifft(Xk.*H));  % 相乘进行卷积
end
Y=Y(:, N:L)';               % 在每帧中只保留最后的M个数据
nm=fix(N/2);
y=Y(nm+1:nm+Lenx )';        % 忽略延迟量,并把2维变成1维,取输出与输入x等长
