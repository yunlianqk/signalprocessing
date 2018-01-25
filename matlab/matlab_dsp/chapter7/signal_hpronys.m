function Z=signal_hpronys(x,p,fs,er)
warning off
[A,theta, alpha, fr]=hprony(x,p); % 调用hprony函数提取参数
l=0;                              % 
for k=1 : p                       % 寻找频率大于0和幅值大于er的模式
    if A(k)>er & fr(k)>0
        l=l+1; I(l)=k;
    end
end
II=l;                             % 满足频率大于0和幅值大于er的个数
for k=1 : II                      % 把正频率部分的参数存放AA,Alpha,Theta,F0
    AA(k)=A(I(k));
    Theta(k)=theta(I(k));
    Alpha(k)=alpha(I(k))*fs;
    F0(k)=fr(I(k))*fs;
end
[FF,IS]=sort(F0);                 % 对参数以频率排序
for k=1 : II                      % 按排序的序列重新排列AA,Alpha,Theta
    l=IS(k);
    A(k)=AA(l);
    alpha(k)=Alpha(l);
    theta(k)=Theta(l);
end
for k=1 :II                       % 把参数存放在输出变量Z中
    Z(k,1)=alpha(k);
    Z(k,2)=FF(k);
    Z(k,3)=2*A(k);
    Z(k,4)=theta(k);
end
