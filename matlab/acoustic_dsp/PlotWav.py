import matplotlib.pyplot as plt
import scipy as sp


def plotwav(raw_data, xlabel, ylabel, title):

    plt.figure(1)
    plt.plot(raw_data)
    plt.xlabel(xlabel)
    plt.ylabel(ylabel)
    plt.title(title)
    plt.show()

def plotspectum(raw_data1, raw_data2, title, sampling_freq, seg_num):
    # f, t, sxx = sp.signal.spectrogram(raw_data, sampling_freq, nperseg=seg_num)
    # plt.pcolormesh(t, f, sxx)

    plt.subplot(2,1,1)
    plt.specgram(raw_data1, Fs=sampling_freq, NFFT=seg_num)
    plt.xlabel("Time")
    plt.ylabel("Freq")
    plt.title(title)

    plt.subplot(2, 1, 2)
    plt.specgram(raw_data2, Fs=sampling_freq, NFFT=seg_num, mode='psd')
    plt.xlabel("Time")
    plt.ylabel("Freq")

    plt.show()