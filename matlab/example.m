clear, clc, close all

%micInFile = 'data/synthetic/noise_mic20.wav';
%spkInFile = 'data/synthetic/noise_spk.wav';

micInFile = 'data/mirror/mic_c0.wav';
spkInFile = 'data/mirror/spk.wav';

micOutFile = '~/out_c0_linear.wav';

% music program (stochastic non-stationary signal)
[x, fs] = audioread(micInFile);     
x = x(:, 1);                                  

[y, y_fs] = audioread(spkInFile);     
y = y(:, 1);       

% signal parameters
xlen = length(x);                   
t = (0:xlen-1)/fs;                  

% define the analysis and synthesis parameters
wlen = 1024;
hop = wlen/4;
nfft = 10*wlen;

nTaps = 10;
mu_nlms = 0.8;

% perform time-frequency analysis and resynthesis of the original signal
[x_stft, x_f, x_t_stft] = stft(x, wlen, hop, nfft, fs);
[y_stft, y_f, y_t_stft] = stft(y, wlen, hop, nfft, y_fs);

nFrames = min(size(y_stft,2), size(x_stft, 2));

hn = complex(zeros(size(x_stft, 1), nTaps));
en = complex(zeros(size(x_stft, 1), 1));
clean = complex(zeros(size(x_stft, 1), nFrames));

for ii=nTaps:nFrames
    en = x_stft(:,ii) - sum(conj(hn).*(fliplr(y_stft(:,ii-nTaps+1:ii))),2);
    spkPower = sum(y_stft(:,ii-nTaps+1:ii).*conj(y_stft(:,ii-nTaps+1:ii)), 2);
    spkPower = max(spkPower, 1e-6);
    clean(:,ii) = en;
    en = en./spkPower;
    hn = hn + mu_nlms*(fliplr(y_stft(:,ii-nTaps+1:ii))).*repmat(conj(en), 1, nTaps);
end;

[x_istft, t_istft] = istft(clean, wlen, hop, nfft, fs);

plot(x_istft);

audiowrite('~/out.wav', x_istft, fs);