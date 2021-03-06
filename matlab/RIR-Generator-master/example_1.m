c = 340;                    % Sound velocity (m/s)
fs = 16000;                 % Sample frequency (samples/s)
% r = [2.5 2 3;2.6 2 3;2.7 2 3;2.8 2 3];              % Receiver position [x y z] (m)
r = [2.5 2 3;2.54 2 3];              % Receiver position [x y z] (m)
s = [1.0 2 3];              % Source position [x y z] (m)
L = [5 4 6];                % Room dimensions [x y z] (m)
beta = 0.6;                 % Reverberation time (s)
n = 2048;                   % Number of samples

h = rir_generator(c, fs, r, s, L, beta, n);