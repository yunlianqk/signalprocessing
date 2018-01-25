function [xn]=idfs(Xk, N);
% Computing Inverse Discrete Fourier Series
%
% 
n=[0:1:N-1];
k=[0:1:N-1];
WN=exp(-j*2*pi/N);
nk=n'*k;
WNnk=WN.^nk;
xn=(Xk*WNnk)/N;
