function [micOut, erle] = nlms(micSpec, spkSpec, nTaps, mu)

% micOut = nlms(micSpec, spkSpec, nTaps, mu)

assert(size(micSpec,1) == size(spkSpec,1));
nBands = size(micSpec,1);
nFrames = min(size(micSpec, 2), size(spkSpec,2));

adaptSignalThreshold = 0.0032;  % -50 dB
spkSmoothFactor = 0.985;

% pre-allocate memory
micOut = complex(zeros(nBands, nFrames));
h = complex(zeros(nBands, nTaps));   % filter
spkHistory = complex(zeros(nBands, nTaps));
spkHistoryPower = zeros(nBands, 1);
spkSmoothedHistPower = zeros(nBands, 1);
erle = zeros(1, nFrames);

for ii = 1:nFrames
    % update speaker history and power
    A = spkHistory(:,1).*conj(spkHistory(:,1));
    B = spkSpec(:,ii).*conj(spkSpec(:,ii));
    spkHistoryPower = spkHistoryPower - A + B;
    spkSmoothedHistPower = spkSmoothedHistPower * spkSmoothFactor + spkHistoryPower * (1 - spkSmoothFactor);
    % FIFO buffer 16 frames speaker wav
    spkHistory(:, 1:end-1) = spkHistory(:, 2:end);
    spkHistory(:, end) = spkSpec(:, ii);

    % filtering
    echoEstimate = sum(spkHistory.*h, 2);           % calculate echo estimate
    echoEstError = micSpec(:, ii) - echoEstimate;   % calculate echo residual
    micOut(:, ii) = echoEstError;
    erle(ii) = db(sum(micSpec(:, ii).*conj(micSpec(:, ii))/sum(echoEstError.*conj(echoEstError))) + 1.0E-10)/2;
    
    % update filter taps
    if (sum(spkHistoryPower)/(nBands*nTaps) > adaptSignalThreshold^2)
        spkPower = spkHistoryPower + spkSmoothedHistPower;
        spkPower =  max(spkPower, 1e-6);
        Beta = mu * echoEstError./spkPower;
        C = repmat(Beta, 1, nTaps).* conj(spkHistory);
        h = h + C;
    end;
    
    if mod(ii, 100) == 0
        fprintf('nlms %d\n', ii);
    end;
end;
