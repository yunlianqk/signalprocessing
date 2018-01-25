function [voiceseg,vosl,vseg,vsl,T2,Bth,SF,Ef]=pitch_vads(y,fn,T1,r2,miniL,mnlong)
if nargin<6, mnlong=10; end
if nargin<5, miniL=10; end
if size(y,2)~=fn, y=y'; end
wlen=size(y,1);
for i=1:fn
    Sp = abs(fft(y(:,i)));                    % FFT取幅值
    Sp = Sp(1:wlen/2+1);	                  % 只取正频率部分
    Esum(i) = sum(Sp.*Sp);                    % 计算能量值
    prob = Sp/(sum(Sp));	                  % 计算概率
    H(i) = -sum(prob.*log(prob+eps));         % 求谱熵值
end
%hindex=find(H<0.1);
%H(hindex)=max(H);
Ef=sqrt(1 + abs(Esum./H));                    % 计算能熵比
Ef=Ef/max(Ef);                                % 归一化

zindex=find(Ef>=T1);                          % 寻找Ef中大于T1的部分
zseg=findSegment(zindex);                     % 给出端点检测各段的信息
zsl=length(zseg);                             % 给出段数
j=0;
SF=zeros(1,fn);
for k=1 : zsl                                 % 在大于T1中剔除小于miniL的部分
    if zseg(k).duration>=miniL
        j=j+1;
        in1=zseg(k).begin;
        in2=zseg(k).end;
        voiceseg(j).begin=in1;
        voiceseg(j).end=in2;
        voiceseg(j).duration=zseg(k).duration;
        SF(in1:in2)=1;                        % 设置SF
    end
end
vosl=length(voiceseg);  

T2=zeros(1,fn);
j=0;
for k=1 : vosl                                % 在每一个有话段内寻找元音主体
    inx1=voiceseg(k).begin;
    inx2=voiceseg(k).end;
    Eff=Ef(inx1:inx2);                        % 取一个有话段的能熵比
    Emax=max(Eff);                            % 求出该有话段内能熵比的最大值
    Et=Emax*r2;                               % 计算第二个阈值T2
    if Et<T1, Et=T1; end
    T2(inx1:inx2)=Et;
    zindex=find(Eff>=Et);                     % 寻找其中大于T2的部分
    if ~isempty(zindex)
        zseg=findSegment(zindex);
        zsl=length(zseg);
            
        for m=1 : zsl
            if zseg(m).duration>=mnlong       % 只保留长度大于mnlong的元音主体
                j=j+1;
                vseg(j).begin=zseg(m).begin+inx1-1;
                vseg(j).end=zseg(m).end+inx1-1;
                vseg(j).duration=zseg(m).duration;
                Bth(j)=k;                     % 设置该元音主体属于哪一个有话段
                
            end
        end
    end
end
vsl=length(vseg);                             % 求出元音主体个数 




