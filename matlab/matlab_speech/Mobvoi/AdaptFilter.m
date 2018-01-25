function [micOut, erle, spkMicDelay] = AdaptFilter(micSpec, spkSpec, frameLen, nTaps, mu)

% micOut = AdaptFilter(micSpec, spkSpec, nTaps, mu)
% 
% Two-path adaptive filter using NLMS
%

assert(size(micSpec,1) == size(spkSpec,1));
nBands = size(micSpec,1);
nFrames = min(size(micSpec, 2), size(spkSpec,2));

smoothScale = (frameLen/0.01);

adaptSignalThreshold = 0.001;  % -60 dB
spkSmoothFactor = 0.985^smoothScale;

% pre-allocate memory
micOut = complex(zeros(nBands, nFrames));
h_front = complex(zeros(nBands, nTaps));   % front-end filter
h_back = complex(zeros(nBands, nTaps));   % back-end filter

bestResidual = complex(zeros(nBands, 1));
bestResidualPow = zeros(nBands, 1);

spkHistory = complex(zeros(nBands, nTaps));
spkHistoryPower = zeros(nBands, 1);
spkSmoothedHistPower = zeros(nBands, 1);
erle = zeros(1, nFrames);
spkMicDelay = zeros(1, nFrames);        % speaker-mic delay calcualted from filter taps

resPowSmoothFactor = 0.93^smoothScale;      % this is calibrated with 10ms frame size.
transferThresERLE = 2.0;        % transfer threashold (this is power ratio)
transferThresPowRatio = 3.0;    % tranfer thresold on power comparison

for ii = 1:nFrames
    % update speaker history and power
    spkHistoryPower = spkHistoryPower - spkHistory(:,end).*conj(spkHistory(:,end)) + spkSpec(:,ii).*conj(spkSpec(:,ii));
    spkSmoothedHistPower = spkSmoothedHistPower * spkSmoothFactor + spkHistoryPower * (1 - spkSmoothFactor);
    spkHistory(:, 2:end) = spkHistory(:, 1:end-1);
    spkHistory(:, 1) = spkSpec(:, ii);

    micPower = micSpec(:, ii).*conj(micSpec(:, ii));
    if (ii==1)
        avgMicPow = micPower;
    else
        avgMicPow = avgMicPow * resPowSmoothFactor + micPower * (1-resPowSmoothFactor);
    end;
    
    % front path filtering
    temp = spkHistory.*h_front;
    echoEstimate = sum(temp, 2);             % calculate echo estimate
    echoResidualFront = micSpec(:, ii) - echoEstimate;      % calculate echo residual
    resPowFront = echoResidualFront.*conj(echoResidualFront);
    if (ii==1)
        avgResPowFront = resPowFront;
    else
        avgResPowFront = avgResPowFront * resPowSmoothFactor + resPowFront * (1-resPowSmoothFactor);
    end;
    erleFront = avgMicPow./avgResPowFront;                  % smoothed per-band ERLE
    
    % back path filtering
    echoEstimate = sum(spkHistory.*h_back, 2);              % calculate echo estimate
    echoResidualBack = micSpec(:, ii) - echoEstimate;       % calculate echo residual
    resPowBack = echoResidualBack.*conj(echoResidualBack);
    if (ii==1)
        avgResPowBack = resPowBack;
    else
        avgResPowBack = avgResPowBack * resPowSmoothFactor + resPowBack * (1-resPowSmoothFactor);
    end;
    erleBack = avgMicPow./avgResPowBack;                    % smoothed per-band ERLE

    % find best echo residual for each band
    for jj=1:nBands
        lowestResPow = 0;
        if (resPowFront(jj) < resPowBack(jj))
            lowestResPow = resPowFront(jj);
            bestResidual(jj) = echoResidualFront(jj);
        else
            lowestResPow = resPowBack(jj);
            bestResidual(jj) = echoResidualBack(jj);
        end;

        if (lowestResPow > micPower(jj))
            lowestResPow =  micPower(jj);
            bestResidual(jj) = micSpec(jj, ii);
        end;
        bestResidualPow(jj) = lowestResPow;
    end;
    
    micOut(:, ii) = bestResidual;
    erle(ii) = db(sum(micPower)/(sum(bestResidualPow) + 1.0E-10))/2;
    
    % transfer filter coefficients from background to foreground
    nTransferToFront = 0;
    for jj=1:nBands
        if (erleBack(jj) > transferThresERLE && ...
                avgResPowFront(jj) > avgResPowBack(jj) * transferThresPowRatio)
            h_front(jj, :) = h_back(jj, :);
            nTransferToFront = nTransferToFront + 1;
        end;
    end;
    nTransferToBack = 0;
    for jj=1:nBands
        if (erleFront(jj) > transferThresERLE && ...
                avgResPowBack(jj) > avgResPowFront(jj) * transferThresPowRatio)
            h_back(jj, :) = h_front(jj, :);
            nTransferToBack = nTransferToBack + 1;
        end;
    end;
    if (nTransferToFront > 0 || nTransferToBack > 0)
        fprintf('    Frame=%d, nTransferToFront=%d, nTransferToBack=%d\n', ii, nTransferToFront, nTransferToBack);
    end;
    
    % update filter taps for background filter. 
    if (sum(spkHistoryPower)/(nBands*nTaps) > adaptSignalThreshold^2)
        spkPower = spkHistoryPower + spkSmoothedHistPower;
        spkPower =  max(spkPower, 1e-6);
        Beta = mu * echoResidualBack./spkPower;
        h_back = h_back + repmat(Beta, 1, nTaps).* conj(spkHistory);
    end;
    
    % Calculated speaker-mic delay from filter taps for echo suppression
    if (erle(ii) > 2)   % 3dB
        tapPower = sum(h_front.*conj(h_front), 1);
        [maxPower, delayIdx] = max(tapPower);
        spkMicDelay(ii) = delayIdx - 1;         % use C-style index
    elseif (ii>1)
        spkMicDelay(ii) = spkMicDelay(ii-1);
    end;
    
    if mod(ii, 100) == 0
        fprintf('%d\n', ii);
    end;
end;
