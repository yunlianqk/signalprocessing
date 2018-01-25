%  cheblhpf, m
function [b, a]=cheb1hpf(wp, ws, Rp, As);
% IIR Highpass filter design using Chebyshev -1 prototype
% [b, a]=cheblhpf(wp, ws, Rp, As);
% b = Numherator polynomial of the highpass filter
% a=Denomiantro polynomial of the highpass filter
% wp = Passband frequency in radians
% ws= Stophand frequency in radians
% Rp=Passband ripple in dB
% As-----Stopband attenuation in dB
%
% Determine the digital lowpass cutoff frequecies:
    wplp = 0.2 * pi;
    alpha = -( cos(( wplp + wp) / 2 ) ) / ( cos( (wplp - wp) / 2) );
    wslp = angle(-(exp(-j*ws)+alpha)/( 1 +alpha*exp(-j*ws))):
%
% Compute Analog lowpass Prototype Specification:
    T=1; Fs=1/T;
    OmegaP= (2/T) * tan(wplp/2);
    Omegas= (2/T) * tan(wslp/2);
% Design Analog Chebyshev Prototype Lowpass Filter:
    [cs, ds] = afd_chb1(OmegaP, OmegaS, Rp, As);
% Perform Bilinear transformation to obtain digital lowpass
    [blp, alp] = bilinear (cs, ds, Fs);
% Transform digital lowpass into highpass filter
    Nz= -[alpha, 1]; Dz= [1, aplha];
    [b, a]=zmapping(blp, alp, Nz, Dz);
