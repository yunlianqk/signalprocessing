import numpy as np
import matplotlib.pyplot as plt
import scipy.signal as sig
import scipy.fftpack as fft
from mpl_toolkits.mplot3d import Axes3D



##### EDIT STUFF HERE TO TEST #####
Azimuth = 21 # Azimuth of incoming signal
Elevation = 123 # Elevation of incoming signal
SampleSize = 2000 # Size of data sample
SamplingRate = 100000.0 # Sampling rate (include decimal place)
NoiseVariance = 0.01 # Variance of signal noise (Variance = SD^2)
BandpassLow = 36000 # Lower limit of Butterworth bandpass filter
BandpassHigh = 39000 # Upper limit of Butterworth bandpass filter
BandpassOrder = 5 # Butterworth filter order



##### Signal generation #####

# Signal Direction
az = np.matrix([[Azimuth]]) # Azimuth
el = np.matrix([[Elevation]]) # Elevation
M = len(az) # Number of sources
print 'M ',M


##### Received signals #####

# Data collection
L = SampleSize # Sample size
rate = SamplingRate # Sampling rate
step = np.arange(0, L / rate, 1 / rate) # Time step
freq = 37500 # Frequency of wave
speed = 1484.0 # Speed of wave

# Wavenumber vectors
k = np.zeros(shape=(3, M))
for i in range(M):
    k[0, i] = (2 * np.pi / (speed / freq)) * np.cos(az[i] * np.pi / 180) * np.sin(el[i] * np.pi / 180)
    k[1, i] = (2 * np.pi / (speed / freq)) * np.sin(az[i] * np.pi / 180) * np.sin(el[i] * np.pi / 180)
    k[2, i] = (2 * np.pi / (speed / freq)) * np.cos(el[i] * np.pi / 180)

# Array geometry
N = 3
r = np.matrix([[0., 0., 0.], [0.04, 0., 0.], [0., 0.04, 0.]])

# Delay vector
A = np.exp(-1j * r * k)

# Additive noise
sigma2 = NoiseVariance
n = np.sqrt(sigma2) * (np.random.rand(N, L)) / np.sqrt(2)



# Received signal
m = np.zeros(shape=(N, L))
for i in range(N):
    for j in range(L):
        m[i, j] = np.sin(2 * np.pi * freq * step[j] + np.angle(A[i]))
x = m + n
print 'signal: ', x


##### Signal Pre-processing #####
# Bandpass filter
nyq = 0.5 * (SamplingRate)
low = BandpassLow / nyq
high = BandpassHigh / nyq


#generate iir filter numerator and denometor polynomials
b,a = sig.butter(BandpassOrder, [low, high], 'bandpass')

#filter each channel, a total 3 in this example
x[0] = sig.lfilter(b,a,x[0])
x[1] = sig.lfilter(b,a,x[1])
x[2] = sig.lfilter(b,a,x[2])

# Fourier transformation
FFT = fft.fft(x)
print FFT[0],FFT[1],FFT[2]
# print np.argmax(np.abs(FFT[0])), np.argmax(np.abs(FFT[1])), np.argmax(np.abs(FFT[2]))

# Signal with phase information at desired frequency
W = np.matrix([[FFT[0][np.argmax(np.abs(FFT[0]))]], [FFT[1][np.argmax(np.abs(FFT[1]))]], [FFT[2][np.argmax(np.abs(FFT[2]))]]])

##### Music Algorithm #####

# Sample covariance matrix
# getH returns complex conjugate transpose
# Rxx is the signal covariance matrix
Rxx = W * np.matrix.getH(W) / L

# print 'Input covariance matrix: ', Rxx

##### Eigendecompose

#Solving for eigenvalues and eigenvectors of Rxx
[D, E] = np.linalg.eigh(Rxx)

print D

D = np.real(D)

print "Eigenvalues: ", D
idx = D.argsort()[::1]
print idx


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
print(AzRange[P], ElRange[Q])



##### Display #####

# Plot
fig = plt.figure()
ax = fig.add_subplot(111, projection='3d')
[x, y] = np.meshgrid(ElRange, AzRange)
ax.plot_surface(x, y, -np.log10(Z))
ax.set_xlabel('Elevation Angel(Degrees)')
ax.set_ylabel('Azimuth Angel(Degrees)')
ax.set_zlabel('Gain Metrics')
plt.show()
