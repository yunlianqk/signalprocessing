clear all;

resampleRate = 3;

InFile = './data/in_16.wav';
OutFile = './data/out.wav';

frameLen = 10;

assert(frameLen == 10 || frameLen == 20);

[in, fs] = audioread(InFile);
if size(in, 2) > 1
    in(:, 2:end) = [];
end;

frameSize = frameLen*fs/1000;
numBands = frameSize * 2;

% load filterbank filter coefficients
h = loadFbCoef(numBands);
freqEnergyFactor = 1/sum(h.^2);
% in this specific filter-bank design, delay is 3 frames
fbDelay = 3;

% Forward filterbank analysis
inSpec = DftFB(in, frameSize, numBands, h, length(h)/numBands);

% Inverse filterbank analysis
out = InvDftFB(inSpec, frameSize, numBands, h, length(h)/numBands, resampleRate);
audiowrite(OutFile, out, fs*resampleRate);
