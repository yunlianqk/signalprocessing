% Part_II
[x,fs]=wavread(fle);                        % 读入wav文件
x=x-mean(x);                                % 消去直流分量
x=x/max(abs(x));                            % 幅值归一化
y  = enframe(x,wlen,inc)';                  % 分帧
fn  = size(y,2);                            % 取得帧数
time = (0 : length(x)-1)/fs;                % 计算时间坐标
frameTime = frame2time(fn, wlen, inc, fs);  % 计算各帧对应的时间坐标

[voiceseg,vosl,SF,Ef]=pitch_vad1(y,fn,T1);   % 基音的端点检测
