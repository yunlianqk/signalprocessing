function z=conv_ovladd1(x,h,L)
% 用重叠相加法计算卷积 
x=x(:)';                                % 把x转换成一行
NN=length(x);                           % 计算x长
N=length(h);                            % 计算h长
N1=L-N+1;                               % 把x分段的长度 
x1=[x zeros(1,L)];
H=fft(h,L);                             % 求h的FFT为H
J=fix((NN+L)/N1);                       % 求分块个数
y=zeros(1,NN+2*L);                      % 初始化
for k=1 : J                             % 对每段处理
    xx=zeros(1,L);
    MI=(k-1)*N1;                        % 第i段在x上的开始位置-1
    nn=1:N1;
    xx(nn)=x1(nn+MI);                   % 取一段xi
    XX=fft(xx,L);                       % 做 FFT
    YY=XX.*H;                           % 相乘进行卷积
    yy=ifft(YY,L);                      % 做FFT逆变换求出yi
% 相邻段间重叠相加
    if k==1                             % 第1块不需要做重叠相加                          
        for j=1 : L
            y(j)=y(j)+real(yy(j));
        end
    elseif k==J                         % 最后一块只做N1个数据点重叠相加
        for j=1 : N1
            y(MI+j)=y(MI+j)+real(yy(j));                
        end
    else        
        for j=1 : L                     % 从第2块开始每块都要做重叠相加
            y(MI+j)=y(MI+j)+real(yy(j));                
        end
    end
end
nn=floor(N/2);
z=y(nn+1:NN+nn);                        % 忽略延迟量,取输出与输入x等长
