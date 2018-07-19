clear all

% AEC parameters
echoLen  = 160;     % in ms
frameLen  = 10;     % in ms
nu_nlms = 0.8;
filterPaths = 1;    % number of filter path

testcase = 3;

if testcase == 1
    micInFile = 'data/synthetic/noise_mic20.wav';
    spkInFile = 'data/synthetic/noise_spk.wav';
    micOutFile = '~/out20_linear.wav';
elseif testcase == 2
    micInFile = 'data/single_talk/micin_48k.wav';
    spkInFile = 'data/single_talk/spkin_48k.wav';
    micOutFile = '~/out_linear.wav';
elseif testcase == 3
    micInFile = '~/Downloads/mic.wav';
    spkInFile = '~/Downloads/ref.wav';
    micOutFile = '~/Downloads/out.wav';
elseif testcase == 4
    micInFile = 'data/mic_c0.wav';
    spkInFile = 'data/spk.wav';
    micOutFile = 'data/out.wav';
end;
assert(frameLen == 10 || frameLen == 20);

[mic, mic_fs] = audioread(micInFile);
if size(mic, 2) > 1
    mic(:, 2:end) = [];
end;

[spk, spk_fs] = audioread(spkInFile);
if size(spk, 2) > 1
    spk(:, 2:end) = [];
end;

spk = spk(480:end);

assert(mic_fs == spk_fs);      % does not support re-sampling
fs = mic_fs;
if (fs == 16000)
    freqStart = 100;
    freqEnd = 7800;
    lowFreq = 1000;
elseif (fs == 48000)
    freqStart = 100;
    freqEnd = 14000;
    lowFreq = 1000;
else
    error('unsupported sampling rate');
end;
assert(fs/2 > freqEnd);

frameSize = frameLen*fs/1000;
numTaps = ceil(echoLen/frameLen);
numBands = frameSize * 2;
bandInterval = 1000/frameLen/2;    % 2x over-sampling filterbank

firstBand = freqStart/bandInterval;       % C style index
lastBand  = freqEnd/bandInterval - 1;     % C style index
usedBands = (firstBand+1:lastBand+1);

[micSpec, f, t] = stft(mic, 400, 160, 512, fs);
[spkSpec, f, t] = stft(spk, 400, 160, 512, fs);

% cleSpec = Nlms(micSpec, spkSpec);

[cleSpec, erle] = NlmsLi(micSpec, spkSpec, 16, 0.8);

[cleOut, t] = istft(cleSpec, 400, 160, 512, fs);

% Inverse filterbank analysis

audiowrite(micOutFile, cleOut, fs);