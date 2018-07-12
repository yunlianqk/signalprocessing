clear all;

frameLen = 10;

Lm = 1;
Lc = 20; %300ms
D = 3; %30ms
F = 2;
Iteration = 3;
Epsilon = 1e-10;

ch1File = './data/derev/metroplex_ch1.wav';
ch2File = './data/derev/metroplex_ch2.wav';
ch3File = './data/derev/metroplex_ch3.wav';
ch4File = './data/derev/metroplex_ch4.wav';

out1File = './data/derev/metroplex_out_ch1.wav';

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

var = zeros(size(ch1Spec, 2), 1);

spec = vertcat(ch1Spec, ch2Spec, ch3Spec, ch4Spec);
Lc = ceil(F*frameSize*Lc/numBands);
D = ceil(F*frameSize*D/numBands);

Mu = zeros(Lm*Lc,1,size(ch1Spec,1));
Fi = zeros(Lm*Lc,Lm*Lc,size(ch1Spec,1));
K = zeros(Lm*Lc,1,size(ch1Spec,1));
alpha = 0.99;

X = zeros(Lm*Lc, 1);
dCh1 = zeros(size(ch1Spec));


% Streaming/Adaptive Process

for bands_num = 1:size(ch1Spec, 1)
    Fi(:,:,bands_num)=eye(Lm*Lc);
end;

for ii = Lc+D+1:size(ch1Spec, 2)
    for bands_num = 1:size(ch1Spec, 1)
        for ch_num = 0:Lm-1
            for kk = 1:Lc
                X(ch_num*Lc + kk)=spec(ch_num*size(ch1Spec,1)+bands_num,ii-D-kk);
            end;
        end;
        dCh1(bands_num, ii)=ch1Spec(bands_num,ii)-Mu(:,:,bands_num)'*X;
        var_ch1 = max(dCh1(bands_num,ii).*conj(dCh1(bands_num,ii)), 0);
        
        K(:,:,bands_num)=Fi(:,:,bands_num)*X/(alpha*var_ch1+X'*Fi(:,:,bands_num)*X);
        Mu(:,:,bands_num)=Mu(:,:,bands_num)+K(:,:,bands_num)*conj(dCh1(bands_num,ii));
        Fi(:,:,bands_num)=(Fi(:,:,bands_num)-K(:,:,bands_num)*X'*Fi(:,:,bands_num))/alpha;
    end;
end;

% Batch Process
%
% for ii=1:size(ch1Spec, 1)
%     for iter = 1:Iteration
%         R = zeros(Lm*Lc);
%         P = zeros(Lm*Lc, 1);
%         for jj = (Lc+D):size(ch1Spec, 2)
%             if iter == 1
%                 var_ch1 = max(ch1Spec(ii, jj).*conj(ch1Spec(ii, jj)), Epsilon);
%                 var_ch2 = max(ch2Spec(ii, jj).*conj(ch2Spec(ii, jj)), Epsilon);
%                 var_ch3 = max(ch3Spec(ii, jj).*conj(ch3Spec(ii, jj)), Epsilon);
%                 var_ch4 = max(ch4Spec(ii, jj).*conj(ch4Spec(ii, jj)), Epsilon);
%                 var(jj)=max([var_ch1 var_ch2 var_ch3 var_ch4]);
%             end;
%             for ll = 0:Lm-1
%                 for kk = 1:Lc
%                     X(ll*Lc + kk)=spec(ll*size(ch1Spec,1)+ii,jj-D-kk+1);
%                 end;
%             end;
%             R = R + ((X*X')./var(jj));
%             P = P + (X*conj(ch1Spec(ii,jj))./var(jj));
%         end;
%         C=pinv(R)*P;
%         for jj = (Lc+D):size(ch1Spec, 2)
%             for ll = 0:Lm-1
%                 for kk = 1:Lc
%                     X(ll*Lc + kk)=spec(ll*size(ch1Spec,1)+ii,jj-D-kk+1);
%                 end;
%             end;
%             dCh1(ii, jj)=ch1Spec(ii, jj) - C'*X;
%             var(jj) = max(dCh1(ii, jj).*conj(dCh1(ii, jj)), Epsilon);
%         end;
%     end;
% end;

ch1Out = InvDftFB(dCh1, frameSize, numBands, h, length(h)/numBands);
audiowrite(out1File, ch1Out, fs);
