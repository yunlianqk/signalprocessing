%   u-chblap, m
function [b, a]=u_chb1ap(N, Rp, Omegac);
%    Unnormalized Chebyshev-1 Analog Lowpass Filter Prototype
%
%       [b, a]=u_chblap(N, Rp, Omegac);
%       b-----numberator polynomial coefficients
%       a=denominator polynomial coefficients
%       N=Order of the Elliptic Filter
%       Rp=Passband Ripple in dB; Rp>0
%       Omegac=Cutoff frequency in radians/sec
%
               [z, p, k] = CHEB1AP(N, Rp);
               a = real(poly(p));
               aNn=a(N+1);
               p=p * Omegac;
               a = real(poly(p));
               aNu=a(N+1);
               k=k * aNu/aNn;
               b0=k;
               B = real(poly(z));
               b=k*B;
