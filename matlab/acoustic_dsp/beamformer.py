import numpy as np
import os
import glob
import matplotlib.pyplot as plt
from scipy.io import wavfile
from vad import vad
import time
np.set_printoptions(threshold=np.nan)


def cbf(nphones,sound_speed,spacing,look_dirs,sampling_rate,samples,phone_data):
    '''function to do conventional beamforming'''
    # allocate space to put data
    bf_data = np.zeros((samples, len(look_dirs)))
    # find time lags between phones and the bf matrix
    time_delays = np.matrix((spacing / sound_speed))
    fft_freqs = np.matrix(np.linspace(0, sampling_rate, samples, endpoint=False)).transpose()
    print fft_freqs.shape
    print time_delays.shape
    for ind, direction in enumerate(look_dirs):
        spacial_filt = 1.0 / nphones * np.exp(-2j * np.pi * fft_freqs * time_delays * np.cos(direction))
    # fft the data, and let's beamform.
    bf_data[:, ind] = np.sum(np.fft.irfft(np.fft.fft(phone_data, samples, 0) * np.array(spacial_filt),samples, 0), 1)
    return bf_data

def prepare_data(voice):
    inside_mic = voice[:, 0]
    outside_mic = voice[:, 1]

    print voice.shape

def main():

    file = 'Recording/DOA_-90to90_degrees_moving.wav'
    # file = 'Recording/DOA_right_0degree.wav'

    fs, voice = wavfile.read(file)

    print 'Sampling Freqency: ', fs
    frames, channels = voice.shape
    print 'Frames: %d  Channels: %d' % (frames, channels)

    nmics = 2
    sound_speed = 343  # meters per second sound speed
    l = 4.5e-3

    spacing = np.linspace(0, l, nmics)  # first and second phone 2 m apart

    sampling_rate = fs  # 100 hz sampling rate
    samples = frames

    time_length = samples / sampling_rate
    print time_length
    signal_hz = 100  # 150hz tone generated somewhere
    window_size = 8000

    data_chunck = voice[16000:16000+window_size,]

    # directions = np.array([-90, -60, -30, 0, 30, 60, 90]) * np.pi / 180  # where the signal will come from

    # for ind, signal_dir in enumerate(directions):

    # search directions in sin spacing, a total of 180 directions, seperated by 1 degree
    search_directions = np.arcsin(np.linspace(-1, 1, 3))

    # allocate space to put data
    bf_voice = np.zeros((window_size, len(search_directions)))
    print bf_voice.shape
    # find time lags between phones and the bf matrix
    time_delays = np.matrix((spacing / sound_speed))


    fft_freq_bins = np.matrix(np.linspace(0, sampling_rate, window_size, endpoint=False)).transpose()

    print fft_freq_bins.shape
    print time_delays.shape

    print time_delays * np.sin(-1.57079633)

    for ind, direction in enumerate(search_directions):
        spacial_filt = 1.0 / nmics * np.exp(-2j * np.pi * fft_freq_bins * time_delays * np.sin(direction))

        print spacial_filt.shape

        bf_voice[:, ind] = np.sum(np.fft.irfft(np.fft.fft(voice, window_size, 0) * np.array(spacial_filt), window_size, 0),)





if __name__ == '__main__':
    main()