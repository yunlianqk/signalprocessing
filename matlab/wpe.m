clear all;

frameLen = 10;

Lm = 4;
Lc = 40; %400ms
D = 3; %30ms
F = 2;
Iteration = 3;


ch1File = './data/derev/megatron_ch1.wav';
ch2File = './data/derev/megatron_ch2.wav';
ch3File = './data/derev/megatron_ch3.wav';
ch4File = './data/derev/megatron_ch4.wav';

out1File = './data/derev/out_ch1.wav';

assert(frameLen == 10 || frameLen == 20);

[ch1, ch1_fs] = audioread(ch1File);
if size(ch1, 2) > 1
    ch1(:, 2:end) = [];
end;

[ch2, ch2_fs] = audioread(ch2File);
if size(ch2, 2) > 1
    ch2(:, 2:end) = [];
end;

[ch3, ch3_fs] = audioread(ch3File);
if size(ch3, 2) > 1
    ch3(:, 2:end) = [];
end;

[ch4, ch4_fs] = audioread(ch4File);
if size(ch4, 2) > 1
    ch4(:, 2:end) = [];
end;

assert(ch1_fs == ch2_fs);      % does not support re-sampling
assert(ch2_fs == ch3_fs);
assert(ch3_fs == ch4_fs);

fs = ch1_fs;

frameSize = frameLen * fs / 1000;
numBands = frameSize * 2;
bandInterval = 1000/frameLen/2;    % 2x over-sampling filterbank

% load filterbank filter coefficients
h = loadFbCoef(numBands);
freqEnergyFactor = 1/sum(h.^2);
% in this specific filter-bank design, delay is 3 frames
fbDelay = 3;



% Forward filterbank analysis
ch1Spec = DftFB(ch1, frameSize, numBands, h, length(h)/numBands);
ch2Spec = DftFB(ch2, frameSize, numBands, h, length(h)/numBands);
ch3Spec = DftFB(ch3, frameSize, numBands, h, length(h)/numBands);
ch4Spec = DftFB(ch4, frameSize, numBands, h, length(h)/numBands);

var = zeros(size(ch1Spec, 1), 1);

spec = vertcat(ch1Spec, ch2Spec, ch3Spec, ch4Spec);
Lc = ceil(F*frameSize*Lc/numBands);
D = ceil(F*frameSize*D/numBands);

X = zeros(Lm*Lc, 1);
dCh1 = zeros(size(ch1Spec));
%out2Spec = zeros(size(ch2Spec));


for ii=1:size(ch1Spec, 1)
    var(ii) = max(ch1Spec(ii).*conj(ch1Spec(ii)));
    for iter = 1:Iteration
        R = zeros(Lm*Lc);
        P = zeros(Lm*Lc, 1);
        for jj = (Lc+D):size(ch1Spec, 2)
            for ll = 0:Lm-1
                for kk = 1:Lc
                    X(ll*Lc + kk)=spec(ll*size(ch1Spec,1)+ii,jj-D-kk+1);
                end;
            end;
            R = R + ((X*X')./var(ii));
            P = P + (X*conj(ch1Spec(ii,jj))./var(ii));
        end;
        C=pinv(R)*P;
        for jj = (Lc+D):size(ch1Spec, 2)
            for ll = 0:Lm-1
                for kk = 1:Lc
                    X(ll*Lc + kk)=spec(ll*size(ch1Spec,1)+ii,jj-D-kk+1);
                end;
            end;
            dCh1(ii, jj)=ch1Spec(ii, jj) - C'*X;
        end;
        var(ii) = max(dCh1(ii).*conj(dCh1(ii)));
        var(ii) = max(var(ii), 1e-10);
    end;
end;


ch1Out = InvDftFB(dCh1, frameSize, numBands, h, length(h)/numBands);
%ch2Out = InvDftFB(ch2Spec, frameSize, numBands, h, length(h)/numBands);
audiowrite(out1File, ch1Out, fs);
%audiowrite(out2File, ch2Out, fs);