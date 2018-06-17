function x = rip(fs, t0, decay)
N=t0*fs;
a = -(decay/20)*log(10)/t0;
x=ones(N,1);
for ii=1:N
    x(ii)=exp(1)^(-a*ii/fs);
end;
r = randn(N, 1);
r = r./max(r);
x = x.*r;