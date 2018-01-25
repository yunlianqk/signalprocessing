function tones=Dtmf_genm1(Nsmp)
%symbol = {'1','2','3','4','5','6','7','8','9','*','0','#'};
lfg = [697 770 852 941]; % Low frequency group
hfg = [1209 1336 1477];  % High frequency group
f  = [];
for c=1:4,
    for r=1:3,
        f = [ f [lfg(c);hfg(r)] ];
    end
end

Fs  = 8000;       % Sampling frequency 8 kHz
N = Nsmp;          % Tones of Nsmp long
t   = (0:N-1)/Fs; % Nsmp samples at Fs
pit = 2*pi*t;

tones = zeros(N,size(f,2));
for toneChoice=1:12,
    % Generate tone
    tones(:,toneChoice) = sum(sin(f(:,toneChoice)*pit))';
    % Plot tone
%    subplot(4,3,toneChoice),plot(t*1e3,tones(:,toneChoice));
%    title(['Symbol "', symbol{toneChoice},'": [',num2str(f(1,toneChoice)),',',num2str(f(2,toneChoice)),']'])
%    set(gca, 'Xlim', [0 25]);
%    ylabel('Amplitude');
%    if toneChoice>9, xlabel('Time (ms)'); end
end
