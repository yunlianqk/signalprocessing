
import numpy as np
import os
import glob
import matplotlib.pyplot as plt
from scipy.io import wavfile
from vad import vad
import time
np.set_printoptions(threshold=np.nan)

# path = 'Recording/0'


options = {'region1': [90, 60], 'region2': [60, 30], 'region3': [30, 0],
               'region4': [0, -30], 'region5': [-30, -60], 'region6': [-60, -90],
               'region7': [-90, -60], 'region8': [-60, -30], 'region9': [-30, 0],
               'region10': [0, 30], 'region11': [30, 60], 'region12': [60, 90]}

regions = {1: range(0, 30), 2: range(30, 60), 3: range(60, 90),
           4: range(-30, 0), 5: range(-60, -30), 6: range(-90, -60)}



def file_reading(path):
    voice_data = {}

    for files in glob.glob(os.path.join(path, '*.wav')):

        channel_num = files[len(files) - 5]
        voice_data["fs{0}".format(channel_num)], voice_data["ch{0}".format(channel_num)] = wavfile.read(files)
    return voice_data


def ch_energ_map(frames, step_size, voice_data, batch_size):
    channel_energy = {}

    # initiate the map
    for element in range(1, 8):
        channel_energy["ch{0}".format(element)] = []

    biggest_energy_mic = []

    for f in range(0, frames - step_size, step_size):

        energy_comparison = []

        for ch in range(1, 8):
            current_window = voice_data["ch{0}".format(ch)][f:f + batch_size, ]
            current_energy = sig_energ(current_window)

            channel_energy["ch{0}".format(ch)].append(current_energy)
            energy_comparison.append(current_energy)

        biggest_energy_mic.append(np.argmax(energy_comparison) + 1)

    return channel_energy, biggest_energy_mic


#use mic1 as a reference signal, the others as comparison signal
def multi_ch_comparison1(voice_data, fs, max_tau, frames, step_size, batch_size):
    compare_map = {}
    tau_map = {}
    direction = {}
    # initiate the map
    for element in range(2, 8):
        tau_map["ch1{0}".format(element)] = []
        direction["ch1{0}".format(element)] = []


    for f in range(0, frames-step_size, step_size):

        for ch in range(1,8):

            compare_map["ch{0}".format(ch)] = voice_data["ch{0}".format(ch)][f:f+batch_size,]

        # after get the compare map for each block, now compute gcc-phat for each pairwise mic
        # compare mic 1 signal with mic 2 - 7, respectively

        sig = compare_map["ch1"]   #channel 1 is the center mic, used as reference signal

        vad_check = compare_map["ch1"]
        vad_check = vad_check.tostring()

        if vad.is_speech(vad_check):

            for mic in range(2, 8):
                refsig = compare_map["ch{0}".format(mic)]

                print
                print mic
                tau = gcc_phat(sig, refsig, fs=fs, max_tau= max_tau, interp=32)
                tau_map["ch1{0}".format(mic)].append(tau)
                theta = np.arcsin(tau / max_tau) * 180 / np.pi
                direction["ch1{0}".format(mic)].append(theta)
                print "channel" + " ch{0}".format(mic), tau

        compare_map.clear()
    return tau_map, direction

#cross compare mic2-5, 3-6 and 4-7, the most seperated mic pairs on the board.
def multi_ch_comparison2(voice_data, fs, max_tau, frames, step_size, batch_size):
    compare_map = {}
    tau_map = {}
    direction = {}
    final_degree = []
    mic_pair = [[2,5], [3,6], [4,7]]

    # initiate the map
    for element in range(3):
        tau_map["ch{0}{1}".format(element+2, element+5)] = []
        direction["ch{0}{1}".format(element+2, element+5)] = []

    for f in range(0, frames-step_size, step_size):

        for ch in range(1,8):

            compare_map["ch{0}".format(ch)] = voice_data["ch{0}".format(ch)][f:f+batch_size,]

        vad_check = compare_map["ch1"]
        vad_check = vad_check.tostring()
        # if vad.is_speech(vad_check):

        tri_degree_pair = []
        # cross compare mic2-5, mic3-6 and mic4-7
        for (sig_mic, ref_mic) in mic_pair:
            sig = compare_map["ch{0}".format(sig_mic)]
            refsig = compare_map["ch{0}".format(ref_mic)]

            tau = gcc_phat(sig, refsig, fs=fs, max_tau=max_tau, interp=16)
            theta = np.arcsin(tau/ max_tau) * 180 / np.pi
            tri_degree_pair.append(theta)
            tau_map["ch{0}{1}".format(sig_mic, ref_mic)].append(tau)
            direction["ch{0}{1}".format(sig_mic, ref_mic)].append(theta)
            print "channel{0}{1} : ".format(sig_mic, ref_mic), tau, theta
        current_degree = final_direction_convert(tri_degree_pair)
        final_degree.append(current_degree[1])
        compare_map.clear()

    return tau_map, direction, final_degree


def sig_energ(signal):
    if len(signal) == 1:
        return np.power(signal[0],2)
    return np.sum(np.power(signal,2))

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

    max_shift = int(interp * n /2)
    if max_tau:
        max_shift = np.minimum(int(interp * fs * max_tau), max_shift)

    cc = np.concatenate((cc[-max_shift:], cc[:max_shift]))

    print
    print "max_shift: ", max_shift
    # find max cross correlation index
    shift = np.argmax(np.abs(cc)) - max_shift
    print "max idx : ", np.argmax(np.abs(cc))
    print "Shift is : ", shift
    tau = shift / float(interp * fs)

    return tau

def moving_average(data, window_size):
    window_size = window_size
    averaged_data = []
    for i in range(0, len(data)-window_size):
        current_window = data[i:i+window_size]
        average_current_window = np.sum(current_window)/ window_size
        averaged_data.append(average_current_window)
    return  averaged_data


def final_direction_convert(tri_degree):
    degree25 = tri_degree[0]
    degree36 = tri_degree[1]
    degree47 = tri_degree[2]
    print degree25, degree36, degree47

    # fusion_degree = np.sqrt(np.power(degree25,2) + np.power(degree36,2) + np.power(degree47,2))

    #there are 12 region divided by 360 degrees, so each region takes 30 degrees

    if degree25 in regions[1] and degree36 in regions[3] and degree47 in regions[2]:
        doa = [0, 30]
    elif degree25 in regions[4] and degree36 in regions[2] and degree47 in regions[3]:
        doa = [30, 60]
    elif degree25 in regions[5] and degree36 in regions[1] and degree47 in regions[3]:
        doa = [60, 90]
    elif degree25 in regions[6] and degree36 in regions[4] and degree47 in regions[2]:
        doa = [90, 120]
    elif degree25 in regions[6] and degree36 in regions[5] and degree47 in regions[1]:
        doa = [120, 150]
    elif degree25 in regions[5] and degree36 in regions[6] and degree47 in regions[4]:
        doa = [150, 180]
    elif degree25 in regions[4] and degree36 in regions[6] and degree47 in regions[5]:
        doa = [180, 210]
    elif degree25 in regions[1] and degree36 in regions[5] and degree47 in regions[6]:
        doa = [210, 240]
    elif degree25 in regions[2] and degree36 in regions[4] and degree47 in regions[6]:
        doa = [240, 270]
    elif degree25 in regions[3] and degree36 in regions[1] and degree47 in regions[5]:
        doa = [270, 300]
    elif degree25 in regions[3] and degree36 in regions[2] and degree47 in regions[4]:
        doa = [300, 330]
    elif degree25 in regions[2] and degree36 in regions[3] and degree47 in regions[1]:
        doa = [330, 360]
    else:
        doa = [0, 0]
    print doa
    return doa



def main():



    # path = 'Recording/sine_wave/0-180(discrete)'
    # path = 'Recording/iphone_record/0-180'
    path = 'Recording/sine_wave/60'
    start = time.time()
    voice_data = file_reading(path)

    frames = voice_data["ch1"].shape[0]
    print frames
    fs = voice_data["fs1"]
    batch = int(0.5*fs)
    step_size = batch/2
    N = fs
    max_tau1 = 0.032 / 343
    max_tau2 = 0.064 / 343

    #step size should be the half of the batch_size for overlapping requirement
    tau_map1, direction1 = multi_ch_comparison1(voice_data, fs, max_tau1, frames, step_size, batch)
    tau_map2, direction2, final_degree = multi_ch_comparison2(voice_data, fs, max_tau2, frames, step_size, batch)
    # channel_energy, biggest_energy_mic = ch_energ_map(frames,step_size, voice_data, 16000)

    end = time.time()
    #
    plt.figure(figsize=(16,9))

    for im in range(2,8):
        # print tau_map["ch1{0}".format(im)]
        plt.subplot(6,1,im-1)
        plt.subplots_adjust(left=0.1, right=0.9, top=0.9, bottom=0.1)
        # plt.plot(voice_data["ch{0}".format(im)])
        # plt.plot(tau_map1["ch1{0}".format(im)])
        plt.plot(direction1["ch1{0}".format(im)])
        plt.title("ch1{0}".format(im))
        # plt.plot(channel_energy["ch{0}".format(im)])

    # plt.figure(figsize=(16, 9))
    #
    # for im in range(2, 8):
    #     # print tau_map["ch1{0}".format(im)]
    #     plt.subplot(6, 1, im - 1)
    #     plt.subplots_adjust(left=0.1, right=0.9, top=0.9, bottom=0.1)
    #     # plt.plot(voice_data["ch{0}".format(im)])
    #     # plt.plot(tau_map1["ch1{0}".format(im)])
    #     plt.plot(direction1["ch1{0}".format(im)])
    #     plt.title("ch1{0}".format(im))
    #     # plt.plot(channel_energy["ch{0}".format(im)])



    plt.figure(figsize=(16, 9))
    plt.title("Time Delay")
    for im in range(3):
        plt.subplot(3,1,im+1)
        plt.subplots_adjust(left=0.1, right=0.9, top=0.9, bottom=0.1)
        plt.plot(tau_map2["ch{0}{1}".format(im+2, im+5)])
        plt.title("ch{0}{1}".format(im+2, im+5))

    ax = plt.figure(figsize=(16, 9))
    for im in range(3):
        plt.subplot(3, 1, im + 1)
        plt.subplots_adjust(left=0.1, right=0.9, top=0.9, bottom=0.1)
        plt.plot(direction2["ch{0}{1}".format(im + 2, im + 5)])
        # plt.plot(moving_average(direction2["ch{0}{1}".format(im + 2, im + 5)], 10))
        # plt.plot(moving_average(direction2["ch{0}{1}".format(im + 2, im + 5)], 30))
        # plt.plot(moving_average(direction2["ch{0}{1}".format(im + 2, im + 5)], 50))
        plt.title("ch{0}{1}".format(im + 2, im + 5))
    # #
    # plt.figure(figsize=(16, 9))
    # plt.plot(final_degree)


    # plt.figure(figsize=(16, 9))
    # plt.plot(biggest_energy_mic, 'bo')

    plt.show()

    print
    print "time elapsed: ", end-start




if __name__ == "__main__":
    main()