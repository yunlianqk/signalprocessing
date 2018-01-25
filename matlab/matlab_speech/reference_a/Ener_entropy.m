function Ef=Ener_entropy(y,fn)
if size(y,2)~=fn, y=y'; end
wlen=size(y,1);
for i=1:fn
    Sp = abs(fft(y(:,i)));                    % FFT取幅值
    Sp = Sp(1:wlen/2+1);	              % 只取正频率部分
    Esum(i) = sum(Sp.*Sp);                    % 计算能量值
    prob = Sp/(sum(Sp));	              % 计算概率
    H(i) = -sum(prob.*log(prob+eps));         % 求谱熵值
end
Ef=sqrt(1 + abs(Esum./H));                    % 计算能熵比
Ef=Ef/max(Ef);                                % 归一化

