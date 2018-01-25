clear all

gain = 2;
limit = 0.8;

testcase = 1;

if testcase == 1
    InFile = 'data/test.wav';
    OutFile = '~/drc_out.wav';
end;

[in, fs] = audioread(InFile);

out = Drc(in, fs, gain, limit);

audiowrite(OutFile, out, fs);
