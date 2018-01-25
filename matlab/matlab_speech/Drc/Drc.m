function x = Drc(x, fs, gain, limit)

% x = Drc(x, fs, gain, limit)
% Inputs 
%    x - input time serious
%    fs - sampling rate
%    gain - a fxied scalar gain to be applied before compression
%    limit - compression limit.

if (fs ~= 8000 && fs ~= 16000 && fs ~= 44100 && fs ~= 48000)
    error('Unsupported sampling rate');
end;

if (limit > 0.99)
    error('The amplitude limit must be less than 0.99');
end;

frameSize = round(fs/1000); % 1ms
compressThreshold = limit * 0.9;

nFrames = floor(length(x)/frameSize);

smoothedPeak = 0;
peakSmoothFactor = 0.99;

prevGain = 1;

GAIN = zeros(nFrames,1);

sampleBuffer = x(1:frameSize);
for ii=0:nFrames-2
    index = ii*frameSize + (1:frameSize);
    x_frame = x(index);

    peak = max(abs(x_frame));
    
    if (peak < smoothedPeak)
        level = smoothedPeak;
        smoothedPeak = smoothedPeak*peakSmoothFactor + peak*(1-peakSmoothFactor);
    else
        smoothedPeak = peak;
        level = peak;
    end;
    
    % signal peak after the gain
    targetLevel = level * gain;
    if targetLevel > compressThreshold
        % A simple linear compression. Assume the input signal peak is less
        % than 1.0. Then peak goes above the threshold, compress it to the
        % range [compressThreshold limit]
        newLevel = compressThreshold + (targetLevel - compressThreshold) / (gain - compressThreshold) * (limit - compressThreshold);

        % Just in case input is alreday highter 1.0, it won't go over the limit
        newLevel = min(newLevel, limit*0.9999);
        newGain = newLevel/level;
    else
        newGain = gain;
    end;

    assert(level * newGain <= limit);
    
    GAIN(ii+1,1) = newGain;
    
    % for DRC, we have to look ahead and only output the previous frame. 
    % For the current frame, we have to hold until we know the gain of the
    % next frame.
    gainInterp = prevGain + (newGain - prevGain)*(0:frameSize-1)'/frameSize;
    x(index) = sampleBuffer.*gainInterp;

    sampleBuffer = x_frame;
    prevGain = newGain;
end;

A= GAIN(:,1);

plot(A);
