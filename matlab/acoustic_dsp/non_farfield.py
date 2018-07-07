import numpy as np
import matplotlib.pyplot as plt
import scipy.signal as sig
import scipy.fftpack as fft
from mpl_toolkits.mplot3d import Axes3D



##### EDIT STUFF HERE TO TEST #####
Coord = [-10, 15, -5]
SampleSize = 2000 # Size of data sample
SamplingRate = 100000.0 # Sampling rate (include decimal place)
NoiseVariance = 0.01 # Variance of signal noise (Variance = SD^2)
BandpassLow = 36000 # Lower limit of Butterworth bandpass filter
BandpassHigh = 39000 # Upper limit of Butterworth bandpass filter
BandpassOrder = 5 # Butterworth filter order



##### Signal generation #####

# Signal Direction
az = np.arctan2(Coord[1], Coord[0]) * 180 / np.pi # Azimuth
el = np.arctan2(np.sqrt(Coord[0]**2+Coord[1]**2), Coord[2]) * 180 / np.pi # Elevation
M = 1
print az, el


##### Received signals #####

# Data collection
L = SampleSize # Sample size
rate = SamplingRate # Sampling rate
step = np.arange(0, L / rate, 1 / rate) # Time step
freq = 37500 # Frequency of wave
speed = 1484.0 # Speed of wave

# Array geometry
N = 3
r = np.matrix([[0., 0., 0.], [0.04, 0., 0.], [0., 0.04, 0.]])

# Wavenumber vectors
A = np.zeros(shape=(3, M))
A[0, 0] = (2 * np.pi / (speed / freq)) * np.sqrt((r[0, 0]-Coord[0])**2 + (r[0, 1]-Coord[1])**2 + (r[0, 2]-Coord[2])**2)
A[1, 0] = (2 * np.pi / (speed / freq)) * np.sqrt((r[1, 0]-Coord[0])**2 + (r[1, 1]-Coord[1])**2 + (r[1, 2]-Coord[2])**2)
A[2, 0] = (2 * np.pi / (speed / freq)) * np.sqrt((r[2, 0]-Coord[0])**2 + (r[2, 1]-Coord[1])**2 + (r[2, 2]-Coord[2])**2)

# Additive noise
sigma2 = NoiseVariance
n = np.sqrt(sigma2) * (np.random.rand(N, L)) / np.sqrt(2)

# Received signal
m = np.zeros(shape=(N, L))
for i in range(N):
    for j in range(L):
        m[i, j] = np.sin(2 * np.pi * freq * step[j] + A[i])
x = m + n   #(num_channel, frames)



##### Signal Pre-processing #####

# Bandpass filter
nyq = 0.5 * (SamplingRate)
low = BandpassLow / nyq
high = BandpassHigh / nyq

print nyq, low, high

b,a = sig.butter(BandpassOrder, [low, high], 'bandpass')
x[0] = sig.lfilter(b,a,x[0])
x[1] = sig.lfilter(b,a,x[1])
x[2] = sig.lfilter(b,a,x[2])

# Fourier transformation
FFT = fft.fft(x)

# Signal with phase information at desired frequency
W = np.matrix([[FFT[0][np.argmax(np.abs(FFT[0]))]], [FFT[1][np.argmax(np.abs(FFT[1]))]], [FFT[2][np.argmax(np.abs(FFT[2]))]]])



##### Music Algorithm #####

# Sample covariance matrix
Rxx = W * np.matrix.getH(W) / L

# Eigendecompose
[D, E] = np.linalg.eigh(Rxx)
D = np.real(D)
idx = D.argsort()[::1]
lmbd = D[idx]
E = E[:, idx]
En = E[:, 0:len(E)-M]

# MUSIC search directions
AzRange = np.arange(0, 361, 1)
ElRange = np.arange(90, 181, 1)
Z = np.zeros(shape=(len(AzRange), len(ElRange)))
for i in range(len(ElRange)):
    # Corresponding points on array manifold to search
    kSearch = np.zeros(shape=(3, 1))
    for j in range(len(AzRange)):
        for p in range(M):
            kSearch[0, p] = (2 * np.pi / (speed / freq)) * np.cos(AzRange[j] * np.pi / 180) * np.sin(ElRange[i] * np.pi / 180)
            kSearch[1, p] = (2 * np.pi / (speed / freq)) * np.sin(AzRange[j] * np.pi / 180) * np.sin(ElRange[i] * np.pi / 180)
            kSearch[2, p] = (2 * np.pi / (speed / freq)) * np.cos(ElRange[i] * np.pi / 180)
        ASearch = np.exp(-1j * r * kSearch)
        Z[j, i] = np.sum(np.square(np.absolute(np.matrix.getH(ASearch) * En)), axis=1)

# Get spherical coordinates
P, Q = np.unravel_index(Z.argmin(), Z.shape)
print AzRange[P], ElRange[Q]



##### Display #####
# Plot
fig = plt.figure()
ax = fig.add_subplot(111, projection='3d')
[x, y] = np.meshgrid(ElRange, AzRange)
ax.plot_surface(x, y, -np.log10(Z))
plt.show()