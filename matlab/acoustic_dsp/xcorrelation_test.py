import numpy as np
import matplotlib.pyplot as plt
import scipy.signal as sig
import scipy.fftpack as fft
from mpl_toolkits.mplot3d import Axes3D
from scipy.io import wavfile
import math
from vad import vad
np.set_printoptions(threshold=np.nan)


def gcc_phat(sig, refsig, fs=1, max_tau=None, interp=4):
    '''
    This function computes the offset between the signal sig and the reference signal refsig
    using the Generalized Cross Correlation - Phase Transform (GCC-PHAT)method.
    '''

    # make sure the length for the FFT is larger or equal than len(sig) + len(refsig)
    n = sig.shape[0] + refsig.shape[0]
    print sig[0:20]
    print refsig[0:20]
    # Generalized Cross Correlation Phase Transform
    SIG = np.fft.rfft(sig, n=n)
    print 'SIG shape: ', SIG[0:20]
    REFSIG = np.fft.rfft(refsig, n=n)
    print 'REFSIG shape: ', REFSIG[0:20]

    R = SIG * np.conj(REFSIG)
    print "R shape is: ", R.shape
    xspec = R/np.abs(R)

    cc = np.fft.irfft(R / np.abs(R), n=interp*n)
    print "cc shape: ", cc.shape
    print cc[0:8]
    print cc[cc.shape[0]-1]

    max_shift = int(interp * n / 2)

    if max_tau:
        max_shift = np.minimum(int(interp * fs * max_tau), max_shift)
        print "max_shift is : ", max_shift
        # print int(interp * fs * max_tau)

    cc = np.concatenate((cc[-max_shift:], cc[:max_shift + 1]))
    print "cc is: ", cc
    print "argmax is : ", np.argmax(np.abs(cc))


    # find max cross correlation index
    shift = np.argmax(np.abs(cc)) - max_shift
    print "Shift is : ", shift
    tau = shift / float(interp * fs)
    print "tau is: ", tau
    return tau



file = '/home/mobvoi/PycharmProjects/acoustic_dsp/BSS/Recording/DOA_-90to90_degrees_moving.wav'
# file = '/home/mobvoi/PycharmProjects/acoustic_dsp/BSS/Recording/DOA_30to45_degrees.wav'

fs, voice = wavfile.read(file)

print 'Sampling Freqency: ', fs
frames, channels = voice.shape
print 'Frames: %d  Channels: %d' % (frames, channels)

current_voice = voice[920000:920000+16000, ]
print current_voice.shape

cur_ins_mic = current_voice[:, 0]
cur_out_mic = current_voice[:, 1]
# print cur_ins_mic
# print cur_out_mic

max_tau = 0.045/343

tau = gcc_phat(cur_ins_mic, cur_out_mic, fs=fs, max_tau=max_tau, interp=4)