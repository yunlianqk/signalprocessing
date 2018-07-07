import pyaudio
import sys
import PlayAudio as play
import wave
import sounddevice as sd
#
# chunk = 1024
# FORMAT = pyaudio.paInt16
# CHANNELS = 1
# RATE = 8000
# RECORD_SECONDS = 5
#
# p = pyaudio.PyAudio()
#
# stream = p.open(format=FORMAT,
#                 channels=CHANNELS,
#                 rate=RATE,
#                 input=True,
#                 output=True,
#                 frames_per_buffer=chunk)
# frames = []
#
# print "* recording"
# for i in range(0, RATE / chunk * RECORD_SECONDS):
#     data = stream.read(chunk)
#     # check for silence here by comparing the level with 0 (or some threshold) for
#     # the contents of data.
#     # then write data or not to a file
#     frames.append(data)
#
# print "* done"
#
# stream.stop_stream()
# stream.close()
# p.terminate()
#
#
# wf = wave.open('out.wav', 'wb')
# wf.setnchannels(CHANNELS)
# wf.setsampwidth(p.get_sample_size(FORMAT))
# wf.setframerate(RATE)
# wf.writeframes(b''.join(frames))
# wf.close()
#
# play.play_raw_audio('/experiment_output/out.wav')

fs = 16000
duration = 5
myrecording = sd.rec(duration*fs, samplerate=fs, channels=1, dtype='float64')
print "Recording Audio"
sd.wait()
print "Audio recording complete , Play Audio"
sd.play(myrecording, fs)
sd.wait()
print "Play Audio Complete"