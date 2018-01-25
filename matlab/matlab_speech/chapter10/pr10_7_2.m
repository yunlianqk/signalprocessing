%
% pr10_7_2 
clear all; clc; close all;

global config;                          % 全局变量config
config.pitchScale           = 2.0;	    % 设置基频修改因子
config.timeScale            = 1.5;	    % 设置时长修改因子
config.resamplingScale      = 1;		% 重采样
config.reconstruct          = 0;		% 如果为真进行低通谱重构
config.cutOffFreq           = 500;	    % 低通滤波器的截止频率

global data;            % 全局变量data,先初始化
data.waveOut = [];		% 按基频修改因子和时长修改因子调整后的合成语音输出
data.pitchMarks = [];	% 输入语音信号的基音脉冲标注
data.Candidates = [];	% 输入语音信号基音脉冲标注的候选名单

filedir=[];                               % 设置数据文件的路径
filename='colorcloud.wav';                % 设置数据文件的名称
fle=[filedir filename]                    % 构成路径和文件名的字符串
[xx,fs]=wavread(fle);                     % 读取文件
xx=xx-mean(xx);                           % 去除直流分量
WaveIn=xx/max(abs(xx));                   % 归一化
N=length(WaveIn);                         % 数据长度
time=(0:N-1)/fs;                          % 求出对应的时间序列

[LowPass] = LowPassFilter(WaveIn, fs, config.cutOffFreq); % 对信号进行低通滤波
PitchContour = PitchEstimation(LowPass, fs);% 求出语音信号的基音轨迹
PitchMarking1(WaveIn, PitchContour, fs);	% 进行基音脉冲标注和PSOLA合成
output=data.waveOut;
N1=length(output);                        % 输出数据长度
time1=(0:N1-1)/fs;                        % 求出输出序列的时间序列
wavplay(xx,fs);
pause(1)
wavplay(output,fs)
% 作图
subplot 211; plot(time,xx,'k'); 
xlabel('时间/s'); ylabel('幅值');
axis([0 max(time) -1 1.2 ]); title('原始语音')
subplot 212; plot(time1,output,'k'); 
xlabel('时间/s'); ylabel('幅值');
axis([0 max(time1) -1 1.5 ]); title('PSOLA合成语音')

