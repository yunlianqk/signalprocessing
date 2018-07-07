
import numpy as np
import matplotlib.pyplot as plt


# functions here
def make_phone_data(nphones,sound_speed,spacing,noise_pwr,signal_pwr,sampling_rate,samples,signal_hz,signal_dir):
    '''function to make simulated phone data'''
    # generate data matrix, samples x nphones
    data = np.sqrt(noise_pwr) * np.random.randn(samples, nphones)
    # data = np.zeros((samples, nphones))
    # make actual signal
    time = np.linspace(0, samples / sampling_rate, samples, endpoint=False);
    signal = np.sqrt(signal_pwr) * np.random.randn(samples)
    # make replica vector to duplicate and delay our time signal
    time_delays = spacing / sound_speed
    fft_freqs = np.matrix(np.linspace(0, sampling_rate, samples, endpoint=False))
    time_delays = np.matrix(np.cos(signal_dir) * time_delays)
    spacial_filt = np.exp(2j * np.pi * fft_freqs.transpose() * time_delays)
    spacial_filt = np.array(spacial_filt).transpose()
    replicas = np.fft.irfft(np.array(np.fft.fft(signal)) * spacial_filt, samples, 1)
    # add to data and then return it
    data = data + replicas.transpose()
    print data.shape
    return data, time


def cbf(nphones,sound_speed,spacing,look_dirs,samples,phone_data):
    '''function to do conventional beamforming'''
    # allocate space to put data
    bf_data = np.zeros((samples, len(look_dirs)))
    print bf_data.shape
    # find time lags between phones and the bf matrix
    time_delays = np.matrix((spacing / sound_speed))
    fft_freqs = np.matrix(np.linspace(0, sampling_rate, samples, endpoint=False)).transpose()
    # print fft_freqs.shape
    # print time_delays.shape
    for ind, direction in enumerate(look_dirs):
        spacial_filt = 1.0 / nphones * np.exp(-2j * np.pi * fft_freqs * time_delays * np.cos(direction))
    # fft the data, and let's beamform.
        bf_data[:, ind] = np.sum(np.fft.irfft(np.fft.fft(phone_data, samples, 0) * np.array(spacial_filt),samples, 0), 1)
    return bf_data


def make_plots(nphones,spacing,phone_data,bf_data,time,sampling_rate,time_length,look_dirs, ind):
    '''function to make our plots'''
    plt.figure()
    # plot data in each phone
    plt.plot(time, phone_data)
    plt.title('received signal by phone')
    plt.xlabel('time in seconds')
    plt.ylabel('amplitude')
    plt.savefig('1_phone_data_' + str(ind) + '.png')
    plt.clf()
    # plot power in each phone
    plt.plot(sum(abs(np.fft.fft(phone_data,samples, 0)) ** 2 / samples ** 2, 0),'-*')
    plt.title('power in each phone')
    plt.xlabel('phone number label')
    plt.ylabel('power in Watts')
    plt.savefig('2_phone_pwr_' + str(ind) + '.png')
    plt.clf()
    # plot data in each beam
    plt.plot(time, bf_data)
    plt.title('received signal by beam')
    plt.xlabel('time in seconds')
    plt.ylabel('amplitude')
    plt.savefig('3_beam_data_' + str(ind) + '.png')
    plt.clf()
    # plot power in each beam
    plt.plot(look_dirs * 180 / np.pi, sum(abs(np.fft.fft(bf_data,samples, 0)) ** 2 / samples ** 2, 0),'-*')
    plt.title('power in each beam')
    plt.xlabel('beam direction in degrees')
    plt.ylabel('power in Watts')
    plt.savefig('4_beam_pwr_' + str(ind) + '.png')
    plt.clf()
    return


def main():
    directions = np.array([180, 60, 90, 45]) * np.pi / 180  # where the signal will come from
    for ind, signal_dir in enumerate(directions):

        look_dirs = np.arccos(np.linspace(-1, 1, 180))  # cosine spacing, 180 dirs
        # make our phone data
        phone_data, time = make_phone_data(nphones, sound_speed, spacing, noise_pwr,
                                           signal_pwr, sampling_rate, samples, signal_hz, signal_dir)
        # do the beamforming
        bf_data = cbf(nphones, sound_speed, spacing, look_dirs, samples, phone_data)
        # make our plots
        make_plots(nphones, spacing, phone_data, bf_data, time, sampling_rate, time_length, look_dirs, ind)


# main stuff here
if __name__ == "__main__":
    nphones = 32  # 32 phones
    sound_speed = 343  # meters per second sound speed
    spacing = np.linspace(0, 64, nphones)  # first and second phone 2 m apart
    noise_pwr = 0.01  # background noise power is .1
    signal_pwr = 1  # sinusoidal signal power is .1 apart
    sampling_rate = 250  # 100 hz sampling rate
    samples = 5000
    time_length = samples / sampling_rate
    signal_hz = 100  # 150hz tone generated somewhere
    main()