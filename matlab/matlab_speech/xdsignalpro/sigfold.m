 % sigfold, m
 function [y, n] = sigfold(x, n);
 % implements y(n)=x(-n)
 % [y, n']=sigsfold(x, n)
 %
 y=fliplr(x);  n=-fliplr(n);
