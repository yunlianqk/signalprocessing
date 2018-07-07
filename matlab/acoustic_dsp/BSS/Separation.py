import time
from scipy.io import wavfile
import numpy as np
import matplotlib.pyplot as plt
from sklearn.decomposition import FastICA
import PlayAudio as play
import sounddevice as sd


fs_1, voice_1 = wavfile.read('/home/mobvoi/PycharmProjects/acoustic_dsp/mp3/One.wav')
fs_2, voice_2 = wavfile.read('/home/mobvoi/PycharmProjects/acoustic_dsp/mp3/Two.wav')

print type(voice_1)
print voice_1.shape
print voice_2.shape

# play.play_modified_audio(voice_2,fs_2)



#make sure that 2 voice files have the same size
frames, channels = voice_1.shape
voice_1 = voice_1[:frames/2,0]   #get the first channel
voice_2 = voice_2[:frames/2,0] # get the same length of voice_1, and the first channel

print voice_1.shape
print voice_2.shape

# play.play_modified_audio(voice_1,fs_1)
# play.play_modified_audio(voice_2,fs_2)

figure_1 = plt.figure("Original Signal")
plt.subplot(2, 1, 1)
plt.title("Time Domain Representation of voice_1")
plt.xlabel("Time")
plt.ylabel("Signal")
plt.plot(np.arange(frames/2)/fs_1, voice_1)
plt.subplot(2, 1, 2)
plt.title("Time Domain Representation of voice_2")
plt.plot(np.arange(frames/2)/fs_2, voice_2)
plt.xlabel("Time")
plt.ylabel("Signal")



#concatenate two voice into dual channels
voice = np.c_[voice_1, voice_2]

A = np.array([[1, 0.5], [0.5, 1]])
print A
X = np.dot(voice, A)

# play.play_modified_audio(X,fs_1,True)

# plotting time domain representation of mixed signal
figure_2 = plt.figure("Mixed Signal")
plt.subplot(2, 1, 1)
plt.title("Time Domain Representation of mixed voice_1")
plt.xlabel("Time")
plt.ylabel("Signal")
plt.plot(np.arange(frames/2)/fs_1, X[:, 0])
plt.subplot(2, 1, 2)
plt.title("Time Domain Representation of mixed voice_2")
plt.plot(np.arange(frames/2)/fs_2, X[:, 1])
plt.xlabel("Time")
plt.ylabel("Signal")

#ICA bind source separation
ica = FastICA()
print 'Training ICA decomposer .....'
t_start = time.time()
ica.fit(X)
t_stop = time.time() - t_start

print "Training Complete; took %f seconds" % (t_stop)

S_ = ica.transform(X)



# get the estimated mixing matrix
A_ = ica.mixing_
assert np.allclose(X, np.dot(S_, A_.T) + ica.mean_)

sep1 = S_[:, 0]
sep2 = S_[:, 1]

# play.play_modified_audio(sep1,fs_1, True)
# play.play_modified_audio(sep2,fs_2,True)
play.play_modified_audio(S_,fs_2,True)


# plotting time domain representation of estimated signal
figure_3 = plt.figure("Estimated Signal")
plt.subplot(2, 1, 1)
plt.title("Time Domain Representation of estimated voice_1")
plt.xlabel("Time")
plt.ylabel("Signal")
plt.plot(np.arange(frames/2)/fs_1, S_[:, 0])
plt.subplot(2, 1, 2)
plt.title("Time Domain Representation of estimated voice_2")
plt.plot(np.arange(frames/2)/fs_2, S_[:, 1])
plt.xlabel("Time")
plt.ylabel("Signal")

plt.show()
