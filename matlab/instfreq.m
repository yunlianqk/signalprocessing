function [f0, t0] = instfreq(WaveFileName, ToneFreq, Delay, FilterLen, ReferenceFs, PostFilterLen)

%
% [f0, t0] = instfreq(WaveFileName, ToneFreq, Delay, FilterLen,
%                     ReferenceFs, PostFilterLen)
% Measure instant frequency of sine wave catpure signals.
%
% WaveFileName - File name of the recorded sine wave signal
% ToneFreq - Nominal frequency of the sine wave
% Delay - Delay of the measure in seconds (default 0.1)
% FilterLen - Filter length (default 0.05 second)
% ReferenceFs - Reference sampling rate. If this is specified, the sampling
%       rate deviation will be plot with respect to the reference sampling rate
% PostFilterLen - Post smoothing filter length
% f0 - If reference sampling rate is specified, this is the actual device
%      sampling rate measurement. If refernece sampling is not specified,
%      then this is the raw instant frequency. Default is 0.
% t0 - Time where instant frequency or device sampling rate is measured.

if (nargin < 2)
    error('  Usage: InstFreq(WaveFileName, ToneFreq, Delay, FilterLen)');
end;

if (nargin < 3)
    Delay = 0.1;
end;

if (nargin < 4)
    FilterLen = 0.05;   % 50 ms by default
end;

if (nargin < 5 | isempty(ReferenceFs))
    ReferenceFs = 0;
end;

if (nargin < 6)
    PostFilterLen = 0;
end;

if (FilterLen > 1)
    error('Filter length is too long. It should be < 1 second');
end;

[x,fs] = audioread(WaveFileName);
x = x(:,1);

% Do up-sampling
up_ratio = 2;

if (up_ratio > 1)
    x2 = zeros(length(x)*up_ratio, 1);
    x2(1:up_ratio:length(x2)) = x;

    x = x2;
    fs = fs*up_ratio;
    ReferenceFs = ReferenceFs * up_ratio;
end;

nh = fs*FilterLen;
h = cos(2*pi*ToneFreq*(0:nh-1)'/fs);
%plot(x);
%hold on;
h = h.*hanning(nh);
y = filter(h, 1, x);
plot(y);
FrontCut = round(fs*(Delay + FilterLen));

% remove the first 100ms data because of capture-render delay and filter delay
y = y(FrontCut+1:end);

ny = length(y);
ty = ((0:ny-1) + FrontCut)/fs;

ZcIndex = find(y(1:ny-1)<=0 & y(2:ny)>0);

zc = zeros(length(ZcIndex), 1);
for ii = 1:length(ZcIndex)
    zc(ii) = ty(ZcIndex(ii)) + (0-y(ZcIndex(ii)))/(y(ZcIndex(ii)+1)-y(ZcIndex(ii)))/fs;
end;
% plot(zc);
IF = 1./diff(zc);
% plot(IF);
IF = filter(ones(11,1)/11,1,IF);
IF(1:11) = ToneFreq;

% apply post filter on IF result with the same filter length
nc = round(PostFilterLen*ToneFreq);
if (nc > 2)
    IF = filter(ones(nc,1)/nc, 1, IF);
    IF(1:nc) = ToneFreq;
end;

if nargout > 1
    if (ReferenceFs == 0)
        f0 = IF;
    else
        f0 = IF*(ReferenceFs/ToneFreq);
    end;
end;
if nargout == 2
    t0 = zc(1:end-1);
end;

figure(11);clf
if (ReferenceFs == 0)
    plot(zc(1:end-1), IF);
    grid on
    xlabel('Time (sec)');
    ylabel('Instant Freq (Hz)');
    title('Instantaneous Frequency Test');
else
    plot(zc(1:end-1), IF*(ReferenceFs/ToneFreq) - ReferenceFs);
    grid on
    xlabel('Time (sec)');
    ylabel('Sampling Freq Deviation (Hz)');
    title(['Sampling Rate Test. Reference sampling rate ' int2str(ReferenceFs) ' Hz']);
end;
