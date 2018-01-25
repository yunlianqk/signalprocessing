function [DIST,s1lpcc,s2lpcc]=lpcc_dist(s1,s2,wlen,inc,p)

y1=enframe(s1,wlen,inc)';      % 对s1和s2进行分帧
y2=enframe(s2,wlen,inc)';
fn=size(y1,2);
for i=1 : fn                   % 计算s1和s2每帧的lpcc系数
    u1=y1(:,i);
    ar1=lpc(u1,p);
    lpcc1=lpc2lpccm(ar1,p,p);
    s1lpcc(i,:)=lpcc1;
    u2=y2(:,i);
    ar2=lpc(u2,p);
    lpcc2=lpc2lpccm(ar2,p,p);
    s2lpcc(i,:)=lpcc2;
end

for i=1 : fn                   % 计算s1lpcc与s2lpcc之间每帧的lpcc距离
    Cn1=s1lpcc(i,:);
    Cn2=s2lpcc(i,:);
    Dstu=0;
    for k=1 : p
        Dstu=Dstu+(Cn1(k)-Cn2(k))^2;
    end
    DIST(i)=Dstu;              % 每帧的lpcc距离
end
