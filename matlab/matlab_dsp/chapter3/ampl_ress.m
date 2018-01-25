function [Hr,w,P,L,type] = ampl_ress(h)
%
% function [Hr,w,P,L] = ampl_ress(h)
% Computes Amplitude response Hr(w) and its polynomial P of order L,
% given a linear-phase FIR filter impulse response h.
% The type of filter is determined automatically by the suroutine.
%
% Hr = Amplitude Response
% w = Frequence between [0 pi] over which Hr is computed
% P = Polynomial coefficients
% L = Order of P
% h = Linear Phase filter impulse response
%
M = length(h);
if rem(M,2)==1
   if all(abs(h(1:(M-1)/2)-h(M:-1:(M+3)/2))<1e-8), 
       [Hr,w,P,L] = hr_type1(h); type=1;
   elseif all(abs(h(1:(M-1)/2)+h(M:-1:(M+3)/2))<1e-8) & h((M+1)/2)==0, 
       [Hr,w,P,L] = hr_type3(h); type=3;
   else disp('not a linear-phase filter, check h'), return,
   end
else
   if all(abs(h(1:M/2)-h(M:-1:M/2+1))<1e-8),
       [Hr,w,P,L] = hr_type2(h); type=2;
   elseif all(abs(h(1:M/2)+h(M:-1:M/2+1))<1e-8), 
       [Hr,w,P,L] = hr_type4(h); type=4;
       else disp('not a linear-phase filter, check h'), return, 
   end
end