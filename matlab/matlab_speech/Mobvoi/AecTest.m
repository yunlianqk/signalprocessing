clear all

% AEC parameters
echoLen  = 160;     % in ms
frameLen  = 10;     % in ms
nu_nlms = 0.8;
filterPaths = 2;    % number of filter path

testcase = 5;

if testcase == 1
    micInFile = 'data/synthetic/noise_mic20.wav';
    spkInFile = 'data/synthetic/noise_spk.wav';
    micOutFile = '~/out_1.wav';
elseif testcase == 2
    micInFile = 'data/single_talk/micin_48k.wav';
    spkInFile = 'data/single_talk/spkin_48k.wav';
    micOutFile = '~/home_out_2.wav';
elseif testcase == 3
    micInFile = 'data/double_talk/micin_48k.wav';
    spkInFile = 'data/double_talk/spkin_48k.wav';
    micOutFile = '~/out_3.wav';
elseif testcase == 4
    micInFile = 'data/mirror/mic_c0.wav';
    spkInFile = 'data/mirror/spk.wav';
    micOutFile = '~/out_4.wav';
elseif testcase == 5
    micInFile = 'data/home/mic_48k_right.wav';
    spkInFile = 'data/home/spk_48k_right.wav';
    micOutFile = '~/clean_48k_right.wav';
elseif testcase == 6
    micInPCM = 'data/home_raw/mic_left.pcm';
    spkInPCM = 'data/home_raw/spk_left.pcm';
    
    micInFile = 'data/home_raw/mic_left.wav';
    spkInFile = 'data/home_raw/spk_left.wav';
    micOutFile = '~/clean_raw_left.wav';
end;

assert(frameLen == 10 || frameLen == 20);

[mic, mic_fs] = audioread(micInFile);

disp(size(mic, 3));
disp(ndims(mic));
ex = mic(:, 2:end);
if size(mic, 2) > 1
    mic(:, 2:end) = [];
end;

[spk, spk_fs] = audioread(spkInFile);
if size(spk, 2) > 1
    spk(:, 2:end) = [];
end;

assert(mic_fs == spk_fs);      % does not support re-sampling
fs = mic_fs;
if (fs == 16000)
    freqStart = 100;
    freqEnd = 7500;
elseif (fs == 48000)
    freqStart = 100;
    freqEnd = 12000;
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

% load filterbank filter coefficients
h = loadFbCoef(numBands);
% plot(h);
freqEnergyFactor = 1/sum(h.^2);
% in this specific filter-bank design, delay is 3 frames
fbDelay = 3;

% Forward filterbank analysis
micSpec = DftFB(mic, frameSize, numBands, h, length(h)/numBands);
%fileID = fopen('~/micSpec.txt','w');
%fprintf(fileID,'%f,%f\n',[real(micSpec(:)),imag(micSpec(:))]');
%fclose(fileID);
spkSpec = DftFB(spk, frameSize, numBands, h, length(h)/numBands);

if (filterPaths == 1)
    %no double talk
    [micSpecOutLinear, erle] = nlms(micSpec(usedBands, :), spkSpec(usedBands, :), numTaps, nu_nlms);
else
    %with double talk
    [micSpecOutLinear, erle, spkMicDelay] = AdaptFilter(micSpec(usedBands, :), spkSpec(usedBands, :), frameLen/1000, numTaps, nu_nlms);
end;
% calculate linear ERLE
erleFreqLinear = filter(ones(20,1)/20, 1, erle);  % %ERLE calcualted in frequency domain

micOutSpecFull = zeros(size(micSpec, 1), size(micSpecOutLinear, 2));
micOutSpecFull(usedBands, :) = micSpecOutLinear;

% Inverse filterbank analysis
micOut = InvDftFB(micOutSpecFull, frameSize, numBands, h, length(h)/numBands);
%micOut = int16(micOut);
audiowrite(micOutFile, micOut, fs);

%[e95p, erleTime] = CalcErle(mic, micOut, frameSize, frameSize*fbDelay, fs);
t_erleTime = (0:length(erleTime)-1)*frameLen/1000;

nFrames = size(micSpecOutLinear, 2);
t_frames = (0:nFrames-1)*frameLen/1000;

figure(101);clf
subplot(211);
plot((0:length(mic)-1)/fs, mic);
hold on
plot((0:length(micOut)-1)/fs, micOut, 'r');
grid on
subplot(212);
plot(t_frames, erleFreqLinear);
hold on
plot(t_erleTime, erleTime, 'g');
grid on
legend('Freq ERLE', 'Time ERLE');

fprintf('ERLE = %.2fdB\n', e95p);
