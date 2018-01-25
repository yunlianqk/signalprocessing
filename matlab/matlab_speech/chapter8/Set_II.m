% Set_II
filedir=[];                    % 设置数据文件的路径
filename='tone4.wav';          % 设置数据文件的名称
fle=[filedir filename]         % 构成路径和文件名的字符串
wlen=320; inc=80;              % 分帧的帧长和帧移
overlap=wlen-inc;              % 帧之间的重叠部分
T1=0.05;                       % 设置基音端点检测的参数
