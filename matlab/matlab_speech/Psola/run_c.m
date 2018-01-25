%--------------------------------------------------------------------------
% main script to do pitch and time scale modification of speech signal
%--------------------------------------------------------------------------
global config;                          % 全局变量config
config.pitchScale           = 1.3;	    % 设置基频修改因子
config.timeScale            = 0.8;	    % 设置时长修改因子
config.resamplingScale      = 1;		% 重采样
config.reconstruct          = 0;		% 如果为真进行低通谱重构
config.displayPitchMarks    = 0;		% 如果为真将显示基音脉冲标注
config.playWavOut           = 1;		% 如果为真将在计算机上播放合成的语音
config.cutOffFreq           = 900;	    % 低通滤波器的截止频率
config.fileIn               = '..\waves\m2.wav';% 输入文件路径和文件名
config.fileOut              = '..\waves\syn.wav';% 输出文件路径和文件名

global data;            % 全局变量config,先初始化
data.waveOut = [];		% 按基频修改因子和时长修改因子调整后的合成语音输出
data.pitchMarks = [];	% 输入语音信号的基音脉冲标注
data.Candidates = [];	% 输入语音信号基音脉冲标注的候选名单

[WaveIn, fs] = wavread(config.fileIn);	   % 读入语音文件
WaveIn = WaveIn - mean(WaveIn); 		   % 清除直流分量

[LowPass] = LowPassFilter(WaveIn, fs, config.cutOffFreq); % 对信号进行低通滤波
PitchContour = PitchEstimation(LowPass, fs);% 求出语音信号的基音参数
PitchMarking(WaveIn, PitchContour, fs);		% 进行基音脉冲标注和PSOLA合成
wavwrite(data.waveOut, fs, config.fileOut);	% 把合成语音写入指定文件

if config.playWavOut
    wavplay(data.waveOut, fs);
end

if config.displayPitchMarks
    PlotPitchMarks(WaveIn, data.candidates, data.pitchMarks, PitchContour); %show the pitch marks
end