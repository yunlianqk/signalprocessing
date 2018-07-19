function [cleSpec] = Nlms(micSpec, spkSpec)

  echoLen = 16;
  mu = 0.8;
  
  [nBands, nFrames] = size(micSpec);
  nFrames = min(nFrames, size(spkSpec, 2));
  w = zeros(echoLen, nBands);
  cleSpec = zeros(nBands, nFrames);
%   spkHistory = zeros(nBands, echoLen);
  
  for iFrames =1+echoLen:nFrames
      for iBands = 1:nBands
         x = spkSpec(iBands, iFrames + (-echoLen:-1));
         x = fliplr(x).';
         d = micSpec(iBands, iFrames).';
         e = d - w(:, iBands)'*x;
         xPower = max(x' * x, 1e-6);
         w(:, iBands) = w(:, iBands) + mu * conj(e) * x/xPower;
         cleSpec(iBands, iFrames) = e;
      end;
  end;
  
end