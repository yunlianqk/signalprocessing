function xout = InvDftFB(X, frameSize, numBands, win, winBlockSize, resampleRate)

% xout = InvDftFB(X, frameSize, numBands, win, winBlockSize)
% DFT filter bank synthesis tool
%

OvrSampRatio = numBands/frameSize;

if (OvrSampRatio < 1)
    error('OvrSampRatio must be > 1');
end;

if (OvrSampRatio ~= 2)
    win = win/sqrt(OvrSampRatio/2);
end;

if (round(log2(OvrSampRatio)) ~= log2(OvrSampRatio))
    error('Over sampling ratio must be power of 2');
end;

Nh = numBands*winBlockSize; % filter length
win = win(:);

if (Nh ~= length(win))
    win = resample(win, Nh, length(win))/sqrt(Nh/length(win));
end;

% undo phase compensation
phase0 = exp(j*2*pi*(0:OvrSampRatio-1)'/OvrSampRatio);
X = X.*phase0(mod((0:numBands/2)'*(0:size(X,2)-1), OvrSampRatio)+1);

% recover negative frequencies
X = [X; conj(flipud(X(2:numBands/2,:)))];
[N1, N2] = size(X);

% inverse FFT
x2 = real(ifft(vertcat(X(1:N1/2,:),zeros((resampleRate-1)*N1, N2),X(N1/2+1:end,:))));

% scale up because the scaling is included in the window function
x2 = x2*N1*resampleRate;

% prepare output buffer
xout = zeros(resampleRate*frameSize*(N2+winBlockSize*OvrSampRatio-1),1); % output

% unfolding
x2 = repmat(x2, winBlockSize, 1);

win = resample(win, resampleRate, 1);

% apply window
x2 = x2.*repmat(win, 1, N2);

% overlap and add
for i=1:N2
    start_index = (i-1)*frameSize*resampleRate;
    xout(start_index + (1:Nh*resampleRate)) = xout(start_index + (1:Nh*resampleRate)) + x2(:,i);
end;


