function Xout = DftFB(x, frameSize, numBands, win, winBlockSize)

% Xout = DftFB(x, frameSize, numBands, win, winBlockSize)
% DFT filter bank analysis tool
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
    %win = resample(win, Nh, length(win))/sqrt(Nh/length(win));
    error('Filter length does not match frame size');
end;

%flip windowing function
win = flipud(win);

% buffer x into a 2D matrix
x2 = buffer(x, Nh, Nh - frameSize);
[N1, N2] = size(x2);

% applying window funciton
x2 = x2.*repmat(win, 1, N2);

% folding
temp = x2(1:numBands, :);
for i=1:winBlockSize-1
    temp = temp + x2(numBands*i + (1:numBands), :);
end;
x2 = temp;

% fft
Xout = fft(x2);

% drop negative frequency component because of symmetry
Xout(numBands/2+2:end,:) = []; 

% phase compensation
phase0 = exp(-j*2*pi*(0:OvrSampRatio-1)'/OvrSampRatio);
Xout = Xout.*phase0(mod((0:numBands/2)'*(0:N2-1), OvrSampRatio)+1);


