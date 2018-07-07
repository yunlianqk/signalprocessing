import numpy as np
import matplotlib.pyplot as plt
import scipy.signal as sig
import scipy.fftpack as fft
from mpl_toolkits.mplot3d import Axes3D
from scipy.io import wavfile
import math
from vad import vad
np.set_printoptions(threshold=np.nan)


def main():

    file = 'Recording/DOA_-90to90_degrees_moving.wav'
    # file = '/home/mobvoi/PycharmProjects/acoustic_dsp/BSS/Recording/DOA_30to45_degrees.wav'

    fs, voice = wavfile.read(file)

    print 'Sampling Freqency: ', fs
    frames, channels = voice.shape
    print 'Frames: %d  Channels: %d' % (frames, channels)

    N = 4096 * 4

    window = np.hanning(fs)

    inside_mic = voice[:, 0]
    outside_mic = voice[:, 1]

    sample_size = 8000
    # print inside_mic[0:fs], outside_mic[0:fs]
    start= 16000
    end= start+sample_size

    siga = inside_mic[start:end]
    sigb = outside_mic[start:end]

    tcorr = np.correlate(siga,sigb,mode='full')
    print 'x_corr size: ', tcorr.shape
    print "Time domain xcorr peak idx: ", np.argmax(tcorr)-(sample_size*2-1)

    ffta = np.fft.rfft(siga, n=2*sample_size)
    fftb = np.fft.rfft(sigb, n=2*sample_size)

    csd = ffta * np.conj(fftb)
    fftcorr = np.fft.ifft(csd / abs(csd), n = 16*sample_size)
    print "fftcorr size: ", fftcorr.shape
    print "Freq domain xcorr peak idx: ", np.argmax(fftcorr)


    print ffta.shape, fftb.shape, fftcorr.shape

    plt.figure(1)
    plt.subplot(3,1,1)
    plt.plot(ffta)
    plt.subplot(3,1,2)
    plt.plot(fftb)
    plt.subplot(3,1,3)
    plt.plot(fftcorr)
    plt.show()







if __name__ == "__main__":
    main()