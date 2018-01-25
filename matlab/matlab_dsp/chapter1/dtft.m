function [X,ph]=DTFT(x,W,n0)
% Computes the DTFT of a given sequence x[n] for digital frequency vector W,
%  regarding the first sample as the n0-th one.
x=x(:).';                  
Nt=length(x); 
n=0:Nt-1;  
if nargin<3, n0=-floor(Nt/2); end
X= x*exp(-1j*(n+n0)'*W); 
if nargout==2, ph=angle(X); X=abs(X);  end
