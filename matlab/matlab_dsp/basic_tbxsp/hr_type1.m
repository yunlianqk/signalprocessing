function [Hr, w, a,L]=hr_type1(h);
%Computes Amplitude response of Type-1 LP FIR filter

M=length(h);
L=(M-1)/2;
a=[h(L+1) 2*h(L:-1:1)];
n=[0:L];
w=[0:500]'*pi/500;
Hr=cos(w*n)*a';
