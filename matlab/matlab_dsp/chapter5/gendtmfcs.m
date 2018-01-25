function y=gendtmfcs(A,dth,Doption)
if nargin<2, dth=0.1; Doption=0; end   % 设置缺省值
if nargin<3, Doption=0; end
fs=8000;                               % 采样频率
Nsmp=ceil(dth*fs);                     % 计算每个DTMF波形的长度
Nsmp2=Nsmp/2;                          % 设置中断的长度
tones=Dtmf_genm1(Nsmp);                % 计算12个字符的DTMF波形存放在tones数组中
pa=zeros(Nsmp2,1);                     % 初始化
y=pa;

la=length(A);                          % 字符长度
for_index=zeros(1,la);                 % 初始化
for k=1 : la                           % 计算每个字符将从tones数组中取第几个波形
    Chr=abs(A(k));                     % 得到字符的ASCII码
    if Chr>48 & Chr<58,                % 若是数字1-9
        ld=Chr-48; %end  
    elseif Chr==48                     % 若是0
        ld=11;
    elseif Chr==42                     % 若是*
        ld=10;
    elseif Chr==35                     % 若是#
        ld=12;
    %elseif Chr>0 & Chr<10
    %    ld=Chr;
    else                               % 都不是,显示错误信息
        disp('错误! 有非电话键盘字符!重新输入.')
    end
    %for_index(k)=ld;                  % 存放要取波形的序列
%end
%for_index
%for i=for_index,
    y=[y; tones(1:Nsmp,ld); pa];       % 从tones数组中取波形构成DTFM波形
end
y=[y; pa];
if nargout==0                          % 函数没有输出将发声
    wavplay(y,fs);
end
if Doption                             % 是否要把波形显示出来
    wavplay(y,fs);
    figure(90)
    M=length(y);
    n=1:M;
    time=(n-1)/fs;
    plot(time,y,'k');
    xlim([0 max(time)]);
    xlabel('时间/s'); ylabel('幅值')
    set(gcf,'color','w');
end

function tones=Dtmf_genm1(Nsmp)
% 只处理电话键盘12个字符
% 12个字符是'1','2','3','4','5','6','7','8','9','*','0','#'
lfg = [697 770 852 941];               % DTMF低频频率
hfg = [1209 1336 1477];                % DTMF高频频率
f  = [];                               % 初始化
for c=1:4,                             % 构成12个频率对的数组
    for r=1:3,
        f = [ f [lfg(c);hfg(r)] ];
    end
end

Fs  = 8000;                            % 采样频率8kHz
N = Nsmp;                              % 每个字符DTMF波形长度
t = (0:N-1)/Fs;                        % 构成时间序列
pit = 2*pi*t;                          % 

tones = zeros(N,size(f,2));            % 初始化
for toneChoice=1:12,                   % 产生12个字符对应DTMF的波形数组
    tones(:,toneChoice) = sum(sin(f(:,toneChoice)*pit))';
end
