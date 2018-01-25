function [y, blocks, blockSize] = frame(x, T, fs)
%[Y, BLOCKS, BLOCKSIZE] = FRAME(X, T, FS) splits a signal vector X
%into segments of length T*1e-3*fs located in the columns of Y.
%
%   Time frame, T, defaults to 20 ms (T=20, => frameLength=T*1e-3*fs)
%
%   Sampling frequency defaults to 16kHz.
   
% Author: Martin Hammer, 2006
%
% Modified: 2006-10-14
% $Rev: 301 $ $Date: 2006-10-14 04:18:54 +0200 (Sat, 14 Oct 2006) $

   if ( nargin < 2 ),
      T = [];
      if ( nargin < 3),
         fs = 16e3;
      end
   end
   if ( isempty(T) ),
      T = 20;
   end
   T = T*1e-3;
   blockSize = T*fs;
   blocks = floor(length(x)/blockSize);

   for i = 0:blocks-1,
      y(:,i+1) = x(i*blockSize+1:(i+1)*blockSize);
   end