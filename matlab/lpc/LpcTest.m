clear all;
close all;

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

wlen = 480;
hop = 160;
nfft = 480;

[stft, f, t] = stft(in, wlen, hop, nfft, fs);
[out, t] = istft(stft, wlen, hop, nfft, fs);

audiowrite(OutFile, out, fs);
