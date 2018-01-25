function [e95p, erle] = CalcErle(input, output, frameSize, outputLatency, fs)

% [erle, e95p] = CalcErle(micIn, micOut, frameSize)
% Calculate ERLE
% Input:
%   input - mic input signal
%   output - AEC output signal
%   frameSize - frame size for analysis. Default 960
%   outputLatency - output latency due to filter bank. Default 960*3
%   fs - sampling rate. Default 48000
% Output:
%   e95p - ERLE at 95 percentile
%   erle - per-frame ERLE with 10 frames moving average

if (nargin < 3)
    frameSize = 960;
end;

if (nargin < 4)
    outputLatency = frameSize * 3;    % latency due to filterbank
end;

if (nargin < 5)
    fs = 48000;
end;

windowSize = frameSize*2;
smoothFilter = ones(1,10)/10;

input2 = buffer(input, windowSize, windowSize-frameSize, 'nodelay');
output2 = buffer(output(outputLatency+1:end), windowSize, windowSize-frameSize, 'nodelay');

N2 = min([size(input2,2) size(output2,2)]);
input2 = input2(:, 1:N2);
output2 = output2(:, 1:N2);

erle = filter(smoothFilter, 1, 10*log10(var(input2)./var(output2)));
erleSorted = sort(erle);
e95p = erleSorted(round(length(erleSorted)*0.95));

if (nargout == 0)
    t = (0:N2-1)*(frameSize/fs);
    plot(t, erle);
    grid on
end;

