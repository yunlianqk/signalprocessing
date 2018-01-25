 % imp-invr, m
 function [b, a]=imp_invr(c, d, T)
 % Impulse Invariance Trans{ormation from Analog to Digital Fiker
 %
 % Eb, aJ=imp_invr(c, d, T)
 % b=Numerator polynomial in z ^ (--1) o{ the digital {ilter
 % a=Denominator polynomial in z ^ (- 1) o{ the digital filter
 % c=Numerator polynomial in s o{ the analog filter
 % d = Denominator polynomial in s o{ the anglog filter
 % T=Sampling (transformation) parameter
 %
 
       [R, p, k]=residue(c, d);
       p=exp(p * T);
       [b, a]=residuez(R, p, k);
       b =real(b');  a=real(a');

