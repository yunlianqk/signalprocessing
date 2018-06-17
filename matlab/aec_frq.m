clear all

nu_nlms = 0.8;

testcase = 4;

nTaps = 3200;
winLen = 480;
frameLen = 160;

if testcase == 1
    micInFile = 'data/synthetic/noise_mic20.wav';
    spkInFile = 'data/synthetic/noise_spk.wav';
    micOutFile = '~/out20_linear.wav';
elseif testcase == 4
    micInFile = 'data/mirror/mic_c0.wav';
    spkInFile = 'data/mirror/spk.wav';
    micOutFile = '~/out_c0_linear.wav';
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

spk2=buffer(spk, 480, 320);
mic2=buffer(mic, 480, 320);
win=hamming(480);

spk3=spk2.*repmat(win, 1, size(spk2, 2));
mic3=mic2.*repmat(win, 1, size(mic2, 2));
spk4=fft(spk3, 480 * 4);
mic4=fft(mic3,480 * 4);

spk5=ifft(spk4);
spk6=spk5.*repmat(win, 1, size(spk5, 2));

xout = zeros(max(size(spk, 1), size(mic, 1)), 1);

for index=1:min(size(mic4, 2),size(spk4,2))
    xout((index-1)*160+1:index*160, 1) = spk2(1:160,index);
end;

plot(xout,'r');
audiowrite(micOutFile, xout, mic_fs);

% hn = complex(zeros(480, 10));
% en = complex(zeros(480, 1));
% 
% clean = complex(zeros(480, size(spk4, 2)));
% 
% for ii=10:size(spk4,2)
%     en = mic4(:,ii) - sum(conj(hn).*(fliplr(spk4(:,ii-10+1:ii))),2);
%     spkPower = sum(spk4(:,ii-10+1:ii).*conj(spk4(:,ii-10+1:ii)), 2);
%     spkPower = max(spkPower, 1e-10);
%     en = en./ spkPower;
%     hn = hn + 0.8*(fliplr(spk4(:,ii-10+1:ii))).*repmat(conj(en), 1, 10);
%     clean(:,ii) = en;
% end;
% 
% clean2=real(ifft(clean));
% 
% xout = zeros(max(size(spk, 1), size(mic, 1)), 1);
% for index=1:min(size(mic4, 2),size(spk4,2))
%     xout((index-1)*160+1:index*160, 1) = clean2(1:160,index);
% end;
% 
% audiowrite(micOutFile, xout/10000, mic_fs);
% 
% figure(1);
% plot(mic,'b')
% figure(2);
% plot(xout/10000,'r');
