function B=goertzel_decode(y,Thd)
fs=8000;                                      % 采样频率
[b,a]=design_cheby2;                          % 带通滤波
x=filtfilt(b,a,y);

tindex=find(x<Thd);                           % 寻找小于阈值的样点
tseg=findSegment(tindex);                     % 寻找小于阈值的区间
tk=length(tseg);                              % 有tk个小于阈值的区间
if tk==0                                      % 错误提示
    disp('寻找不到小于阈值的区间,或许阈值设置不合理,或许不是DTMF波形!!')
    return
end
i=0;                                          % 初始化
for k=1 : tk                                  % 确认DTMF中断的有效性
    if tseg(k).duration>=80                   % TDMF中断时间要大于10ms
        i=i+1;
        nxseg(i).begin=tseg(k).begin;
        nxseg(i).end=tseg(k).end;
        nxseg(i).duration=tseg(k).duration;
    end
end
I=i;                                   % 共有I个DTMF中断

Nt = 205;                              % 设置Goertel算法的长度
lfg = [697 770 852 941];               % DTMF低频率组
hfg = [1209 1336 1477];                % DTMF高频率组
original_f = [lfg(:);hfg(:)];          % 构成高低频数组
K = round(original_f/fs*Nt);           % 计算出高低频在FFT中对应的谱线索引号
estim_f = round(K*fs/Nt);              % 近似的频率值
j=0;                                   % 初始化
if nxseg(1).begin>Nt                   % 是否没有前导静音区间
    j=j+1;                             % 是,一开始就是DTMF波形
    n1=1;                              % 求出该波形的区间
    n2=nxseg(1).begin-1;
    u=x(n1:n2);                        % 取出该波形
    toneuc(:,j) = u(1:Nt);             % 存放在toneuc数组中
end
for i=1 : I-1                          % 寻找下一个DTMF波形
     j=j+1;
     n1=nxseg(i).end+1;                % 求出该波形的区间
     n2=nxseg(i+1).begin-1;
     u=x(n1:n2);                       % 取出该波形
     toneuc(:,j) = u(1:Nt);            % 存放在toneuc数组中
end
I=j;                                   % 典有I个DTMF波形
% 对I个DTMF波形进行Goertzel算法运算
for i=1 : I
    tone=toneuc(:,i);                  % 取来一个DTMF波形
    ydft = goertzel(tone,K+1);         % 进行Goertzel算法运算
    [v1,uk1]=max(ydft(1:4));           % 在低频区间寻找一个最大值
    [v2,uk2]=max(ydft(5:7));           % 在高频区间寻找一个最大值
    f1=lfg(uk1);                       % 对应的低频区间的频率
    f2=hfg(uk2);                       % 对应的高频区间的频率
    Fum(:,i)=[f1 f2];                  % 每一个DTMF波形对形一个频率对[f1 f2]
% 按图5-4-3判断某个频率对是对应于哪一个字符    
    if f1>1000                         % 如果f1和f2位置放反了,要颠倒放过来
        var=f1;
        f1=f2;
        f2=var;
    elseif f1<1000
    end
    
    switch(f1);                        % 用f1来判断
       case{697};                      % f1=697
           switch(f2);                 % 用f2来判断
               case{1209};             % f2=1209
                   taste='1';
               case{1336};             % f2=1336
                   taste='2';
               case{1477};             % f2=1477
                   taste='3';
           end
       case{770};                      % f1=770
           switch(f2);                 % 用f2来判断
               case{1209};             % f2=1209
                   taste='4';
               case{1336};             % f2=1336
                   taste='5';
               case{1477};             % f2=1477
                   taste='6';
           end
        case{852};                     % f1=852
           switch(f2);                 % 用f2来判断
               case{1209};             % f2=1209
                   taste='7';
               case{1336};             % f2=1336
                   taste='8';
               case{1477};             % f2=1477
                   taste='9';
           end
        case{941};                     % f1=941
           switch(f2);                 % 用f2来判断
               case{1209};             % f2=1209
                   taste='*';
               case{1336};             % f2=1336
                   taste='0';
               case{1477};             % f2=1477
                   taste='#';
           end
    end
    B(i)=taste;                        % 把字符的ASCII码存放在B中    
end


