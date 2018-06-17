clear all

nu_nlms = 0.8;

testcase = 1;

nTaps = 3200;
winLen = 480;
frameLen = 160;

if testcase == 1
    micInFile = 'data/synthetic/noise_mic20.wav';
    spkInFile = 'data/synthetic/noise_spk.wav';
    micOutFile = '~/out20_linear.wav';
end;

[mic, mic_fs] = audioread(micInFile);
if size(mic, 2) > 1
    mic(:, 2:end) = [];
end;

[spk, spk_fs] = audioread(spkInFile);
if size(spk, 2) > 1
    spk(:, 2:end) = [];
end;

assert(mic_fs == spk_fs);      % does not support re-sampling

hn = zeros(nTaps, 1);
xn = zeros(nTaps, 1);
clean = zeros(size(spk, 1), 1);

for ii=nTaps:size(spk, 1)
    en = mic(ii, 1) - hn'*flipud(spk(ii-nTaps+1:ii, 1));
    hn = hn + nu_nlms*(en*flipud(spk(ii-nTaps+1:ii, 1))./(spk(ii-nTaps+1:ii, 1)'*spk(ii-nTaps+1:ii, 1)));
    clean(ii) = en;
end;
%plot(mic, 'r');
%hold on;
plot(clean, 'b');
hold on;
