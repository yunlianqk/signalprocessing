function   [A, G, r, a] = autolpc(x, p)
%AUTOLPC      Autocorrelation Method for LPC
%-------            
%   Usage: [A, G, r, a] = autolpc(x, p)
%
%       x : vector of input samples
%       p : LPC model order
%       A : prediction error filter, (A = [1; -a])
%           (NOTE: minus in definition of a_k)
%       G : rms prediction error
%       r : autocorrelation coefficients: lags = 0:p
%       a : predictor coefficients (without minus sign)
%
%--- see also ATOK, KTOA

%---------------------------------------------------------------
% copyright 1994, by C.S. Burrus, J.H. McClellan, A.V. Oppenheim,
% T.W. Parks, R.W. Schafer, & H.W. Schussler.  For use with the book
% "Computer-Based Exercises for Signal Processing Using MATLAB"
% (Prentice-Hall, 1994).
%---------------------------------------------------------------

x = x(:);
L = length(x);
r = zeros(p+1,1);
for i=0:p
   r(i+1) = x(1:L-i)' * x(1+i:L);
end
R = toeplitz(r(1:p));
a = R\r(2:p+1);    %<--- compute inv(R)
A = [1; -a];
G = sqrt(sum(A.*r));