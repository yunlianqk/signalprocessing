function [tfr,fmt,pt] = lpcsgram(sig,Nt,Nf,fs)
% LPCSGRAM Determine the spectrogram from an lpc analysis of the speech signal
%   sig : Input signal
%   Nt  : Number of time points
%   Nf  : Number of frequency pts
%   fs  : Sampling frequency
%   The outputs are:
%   tfr : Time frequency image [NfxNt]
%   fmt : Fmt tracks [3xNt]
%   pt  : Pitch track

if nargin<4,
    fs = 11025;
end;

% Number of lpc coefficients
Nlpc = round(fs/1000)+2;

% Window width
Nwin = floor(length(sig)/Nt);

tfr = zeros(Nf,Nt);
for i=1:Nt,
    % windowed signal
    lpcsig = sig((Nwin*(i-1)+1):min([(Nwin*i) length(sig)]));
    
    if ~isempty(lpcsig),
        % perform lpc analysis
        [A,G] = lpc(lpcsig,Nlpc);
        e = lpcsig-real(filter([0 -A(2:end)],1,lpcsig));
        hf = freqz(sqrt(G),A,Nf);
        
        % Determine the autocorrelation function
        acf = xcorr(e,Nwin,'coeff');

        % Divide the symmetric function in half, excluding peak
        % at the midpoint
        acf = acf((fix(end/2)+2):end);
        idx = find(acf>0.25);
        
        % Determine pitch for the window
        if isempty(idx) | (length(idx)==1 & idx<(fs/300)) | Nwin<100,
            pt(i) = NaN;
        else
            if idx(1)<(fs/300),
                pt(i) = fs/idx(2);
            else,
                pt(i) = fs/idx(1);
            end;
        end
        
        % Determine the formants
        %if G>1.5e-4,
        fmt(:,i) = [frmnts1(A(:),fs)/(fs/2)];
        %else,
        %fmt(:,i) = [NaN;NaN;NaN];
        %end;
        
        % Create a slice of the time-frequency image
        tfr(:,i) = abs(hf(:)); %/norm(abs(hf(:)));
    end;
end;
