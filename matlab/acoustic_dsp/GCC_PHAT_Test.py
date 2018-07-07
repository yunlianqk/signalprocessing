
import numpy as np
import matplotlib.pyplot as plt
import scipy.signal as sig
import scipy.fftpack as fft
from mpl_toolkits.mplot3d import Axes3D
from scipy.io import wavfile
import math
from vad import vad
np.set_printoptions(threshold=np.nan)

def gcc_phat(sig, refsig, fs=1, max_tau=None, interp=16):
    '''
    This function computes the offset between the signal sig and the reference signal refsig
    using the Generalized Cross Correlation - Phase Transform (GCC-PHAT)method.
    '''

    # make sure the length for the FFT is larger or equal than len(sig) + len(refsig)
    n = sig.shape[0] + refsig.shape[0]

    # Generalized Cross Correlation Phase Transform
    SIG = np.fft.rfft(sig, n=n)

    REFSIG = np.fft.rfft(refsig, n=n)

    R = SIG * np.conj(REFSIG)

    cc = np.fft.irfft(R / np.abs(R), n=interp*n)
    # print cc[0:50]

    max_shift = int(interp * n / 2)
    if max_tau:
        max_shift = np.minimum(int(interp * fs * max_tau), max_shift)

    cc = np.concatenate((cc[-max_shift:], cc[:max_shift]))

    print "max_shift: ", max_shift
    # find max cross correlation index
    shift = np.argmax(np.abs(cc)) - max_shift
    print "max idx : ", np.argmax(np.abs(cc))
    print "Shift is : ", shift
    tau = shift / float(interp * fs)

    return tau


def main():

    file = 'Recording/DOA_-90to90_degrees_moving.wav'
    # file = 'Recording/DOA_right_0degree.wav'

    fs, voice = wavfile.read(file)

    print 'Sampling Freqency: ', fs
    frames, channels = voice.shape
    print 'Frames: %d  Channels: %d' % (frames, channels)

    N = 4096 * 4


    inside_mic = voice[:, 0]
    outside_mic = voice[:, 1]

    # print inside_mic[0:fs], outside_mic[0:fs]

    window = np.hanning(fs)

    fresh_window = fs
    step_size = fresh_window/2
    max_tau = 0.045 / 343

    # current_voice = voice[0:fs,]
    # print current_voice.shape


    all_degrees=[]

    all_tau = []
    for i in range(0, frames-step_size, step_size):

        print i, i+fs

        current_voice = voice[i:i+fs,]
        cur_ins_mic = current_voice[:,0]
        cur_out_mic = current_voice[:,1]

        vad_check = cur_ins_mic.tostring()

        if vad.is_speech(vad_check):

            tau = gcc_phat(cur_out_mic, cur_ins_mic, fs=fs, max_tau=max_tau, interp=16)
            all_tau.append(tau)
            print tau / max_tau

            # if tau / max_tau > 1 or tau / max_tau < -1:
            #     continue
            theta = math.asin(tau / max_tau) * 180 / math.pi
            all_degrees.append(theta)
            print "Max Delay: ", max_tau
            print "Current Delay: ", tau
            print "Estimate DOA w.r.t mid point: %d degrees" % theta
            print


    plt.figure(1)
    plt.subplot(2,1,2)
    plt.plot(all_degrees)
    plt.xlabel('Number of Samples')
    plt.ylabel('DOA')
    plt.subplot(2,1,1)
    plt.plot(all_tau)
    plt.xlabel('Number of Samples')
    plt.ylabel('Time(Sec)')
    plt.show()


if __name__ == "__main__":
    main()