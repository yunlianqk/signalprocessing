import numpy as np
import pyaudio
import matplotlib.pyplot as plt
from scipy import signal
p = pyaudio.PyAudio()

volume = 0.5     # range [0.0, 1.0]
fs = 16000       # sampling rate, Hz, must be integer
duration = 8.0   # in seconds, may be float
f = 1000.0        # sine frequency, Hz, may be float

# generate samples, note conversion to float32 array

# delay = np.zeros(1000,np.float32)
# print delay.shape


#sin wave = Asin(2pi*f*t + phi)
samples1 = (np.sin(2*np.pi*np.arange(fs*duration)*f/fs)).astype(np.float32)
samples2 = (np.sin(2*np.pi*np.arange(fs*duration)*f/fs)).astype(np.float32)



# samples1 = np.concatenate([samples1,delay])
# samples2 = np.concatenate([delay,samples2])
# print samples2.shape
#
# fft1 = np.fft.rfft(samples1)
# fft2 = np.fft.rfft(samples2)
#
# xcorr = signal.correlate(samples2, samples1, mode='full')
# csd = fft2*np.conj(fft1)
# fftcorr = np.fft.ifft(csd/abs(csd))
#
# print np.argmax(fftcorr)
#
# plt.plot(samples2)
# # plt.plot(fftcorr)
# # plt.plot(fft2)
# plt.grid()
# plt.subplot(2,1,2)
# plt.plot(xcorr)
# plt.grid()
# plt.show()
# plt.figure()
# plt.subplot(2,1,1)
# plt.plot(samples1)


# for paFloat32 sample values must be in range [-1.0, 1.0]
stream = p.open(format=pyaudio.paFloat32,
                channels=1,
                rate=fs,
                output=True)

# play. May repeat with different volume values (if done interactively)
stream.write(volume*samples1)

stream.stop_stream()
stream.close()

p.terminate()
