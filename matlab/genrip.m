function out = genrip(in, fs, t0)

x = rip(fs, t0, -60);

out = conv(in, x)/(sum(x.*x)^(1/2));

%audiowrite(outFile, y, fs);

