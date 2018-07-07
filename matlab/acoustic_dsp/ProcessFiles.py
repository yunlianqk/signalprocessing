from scipy.io.wavfile import read, write
from scipy.signal import hann
from scipy.fftpack import rfft
from scipy.signal import butter, lfilter, freqz, filtfilt, sosfilt

import scipy as sp
import matplotlib.pyplot as plt
import PlayAudio as play
import PlotWav
import pyaudio
import time
import wave
import acoustics

#read audio samles

file = 'acoustic_files/50899058.wav'


# file = 'mp3/One.wav'
input_raw = read(file)


sampling_freq = input_raw[0] #16000hz
acoustic_data = input_raw[1] #ndarray


lowpassed = acoustics.signal.lowpass(acoustic_data, 1500, sampling_freq)
highpassed = acoustics.signal.highpass(acoustic_data, 4000,sampling_freq)
bandpassed = acoustics.signal.bandpass(acoustic_data, 500, 4000, sampling_freq)
bandstoped = acoustics.signal.bandstop(acoustic_data, 1000, 4000, sampling_freq)
# octavepassed = acoustics.signal.octavepass(acoustic_data,3000, 1,sampling_freq)
# left_channel = acoustic_data[:,0]
# right_channel = acoustic_data[:,1]

# PlotWav.plotwav(acoustic_data,"Time", "Amp", "Sample")
play.play_raw_audio(file)

#

#apply hanning window
# window = hann(acoustic_data.shape[0])
# window_audio = acoustic_data*window

# #fft
# mags = abs(rfft(window_audio))
# #convert to db
# mags = 20 * sp.log10(mags)
#
# #normalise to 0 db max
# mags -= max(mags)


# PlotWav.plotwav(acoustic_data, "Freq Bin", "Mags(dB)", "Spectrum")


PlotWav.plotspectum(acoustic_data,lowpassed, "lowpass filter",sampling_freq, 256)

PlotWav.plotspectum(acoustic_data,highpassed, "hightpass filter", sampling_freq, 256)

PlotWav.plotspectum(acoustic_data,bandpassed, "bandpass filter", sampling_freq, 256)

PlotWav.plotspectum(acoustic_data,bandstoped, "bandstop filter", sampling_freq, 256)

# PlotWav.plotspectum(acoustic_data,octavepassed, "octavepass filter", sampling_freq, 256)

