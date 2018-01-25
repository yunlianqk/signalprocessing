function [Hr, w, c, L]=hr_type3(h);
%Computes Amplitude response of Type-1 LP FIR filter

M=length(h);
L=(M-1)/2;
c=[h(L+1:-1:1)];
n=[0:L];
w=[0:500]'*pi/500;
Hr=sin(w*n)*c';
