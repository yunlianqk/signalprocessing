function [out] = TouchToneDialler(number,SNR);
%
% This function returns an output signal, 'out', that encodes the phone number
% 'number' as a touch tone (DTMF) sequence. The output sampling frequency is 8kHz.
% Each DTMF signal has a duration of approximately 100ms with small gaps
% of approximately 150ms between each key press. The output signal is also
% contaminated with line noise giving a signal to noise ratio of SRN dB.  
%
% input     number      sequence (e.g.['1' '3' '4' '6' '7' '3'])  
%
%           SNR         The Signal to Noise level (dB) of the DTMF signal
%                       to the colored noise
%
% output    out         output signal

[out] = TouchToneSim(number,SNR);
