function [ar,G]=lpc_coefficientm(s,p)
%此函数的功能是用自相关法求信号s使均方预测误差为最小的预测系数
%算法为Durbin快速递推算法
%注：s必须是一维向量 p为预测阶数

n=length(s);                            % 获得信号长度                    
for i=1:p                               
    Rp(i)=sum(s(i+1:n).*s(1:n-i));      % 计算自相关函数
end
Rp_0=s'*s;                              % 即Rn(0)

Ep=zeros(p,1);                          % Ep为p阶最佳线性预测反滤波能量
k=zeros(p,1);                           % k为偏相关系数
a=zeros(p,p);                           % 以上为初始化

%i=1的情况需要特殊处理,也是对p=1进行处理
Ep_0=Rp_0;                              % 按式(4-2-8)
k(1)=Rp(1)/Rp_0;                        % 按式(4-2-9)
a(1,1)=k(1);                            % 按式(4-2-10)
Ep(1)=(1-k(1)^2)*Ep_0;                  % 按式(4-2-12)

%i=2起使用递归算法
if p>1                                                  
    for i=2:p
        k(i)=(Rp(i)-sum( a(1:i-1,i-1).*Rp(i-1:-1:1)'))/Ep(i-1);  % 按式(4-2-9)
        a(i,i)=k(i);                    % 按式(4-2-10)
        Ep(i)=(1-k(i)^2)*Ep(i-1);
        for j=1:i-1
            a(j,i)=a(j,i-1)-k(i)*a(i-j,i-1); % 按式(4-2-11)
        end
    end
end

ar=a(:,p); 
G=sqrt(Ep(p));






