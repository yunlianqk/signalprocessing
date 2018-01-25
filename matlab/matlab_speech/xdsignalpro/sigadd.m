%  sigadd, m
function [y, n]=sigadd(x1, n1, x2, n2)
%  implements y (n) = xl (n) +x2 (n)
%
%  [y, n]=sigadd(x1, n1, x2, n2)
%  y=sum sequence over n, which includes nl and n2
%  x1 =first sequence over n1
%  x2=second sequence over n2(n2 can be different from n1)
%
  n=min(min(n1), min(n2)) : max(max(n1), max(n2));
  y1=zeros(1, length(n));  y2=y1;
  y1(find(n >= min(n1)&(n <= max(n1)) == 1) ) = x1;
  Y2(find(n >= min(n2)&(n <= max(n2)) == 1) ) = x2;
  y=y1+y2;
