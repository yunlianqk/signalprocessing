function RT60=RT60estimator(rev)

%% parameters initialization
fs=16000;
lng=24;   % length of sound (sec)
WinL=fs*0.4; % window length (samples)

%% algorithm
snd = repmat(rev,1,40);
N=fix(length(snd)/WinL); % Number of sound frames

for k=1:N
    header=fix(1+(k-1)*WinL);
    x=snd(header:header+WinL); 
    xlpc=filter(lpc(x,15),1,x); %xlpc=LPCfilter(x,10,16e3); 
    [Rx, lags]=xcorr(xlpc,'unbiased');
    Bck(k,:)=Rx;
end
    
Rx=squeeze(mean(Bck,1)); % averaging on different frames
Rx2=Rx(lags>20 & lags<lags(end)/2); % separating the proper part for extraction
N=100; % averaging filter length
u=conv(abs(Rx2),inv(N)*ones(1,N));u=u(N:end); % averaging the push
Rx3=Rx2(1:find(u<.3*max(u),1)); % selecting initial part of frame for extraction
RT60=3*log(10)/fs/Ratnam(Rx3,fs);

RT60=RT60/1.1;




