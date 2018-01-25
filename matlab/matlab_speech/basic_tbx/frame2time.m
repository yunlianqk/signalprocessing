function frameTime=frame2time(frameNum,framelen,inc,fs)

frameTime=(((1:frameNum)-1)*inc+framelen/2)/fs;

