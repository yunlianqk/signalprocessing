import pyaudio
import wave
import numpy as np
from scipy.io.wavfile import write
import sounddevice as sd

def play_raw_audio(file):

    chunk = 1024
    sound = wave.open(file, 'rb')
    p = pyaudio.PyAudio()
    stream = p.open(format=p.get_format_from_width(sound.getsampwidth()),
                    channels=sound.getnchannels(),
                    rate=sound.getframerate(),
                    output=True)

    data = sound.readframes(chunk)
    print len(data)

    # play stream
    while data:
        stream.write(data)
        data = sound.readframes(chunk)

    # stop stream
    stream.stop_stream()
    stream.close()
    # close PyAudio
    p.terminate()

def play_modified_audio(raw_input, fs, normalized=False):

    if normalized:
        raw_input = np.int16(raw_input / np.max(np.abs(raw_input)) * 32767)
    write('temp.wav', fs, raw_input)
    chunk = 1024
    sound = wave.open('temp.wav', 'rb')
    p = pyaudio.PyAudio()
    stream = p.open(format=p.get_format_from_width(sound.getsampwidth()),
                    channels=sound.getnchannels(),
                    rate=sound.getframerate(),
                    output=True)
    data = sound.readframes(chunk)
    # play stream
    while data:
        stream.write(data)
        data = sound.readframes(chunk)

    # stop stream
    stream.stop_stream()
    stream.close()
    # close PyAudio
    p.terminate()
    #
    # # instantiate PyAudio (1)
    # p = pyaudio.PyAudio()
    #
    # # open stream (2), 2 is size in bytes of int16
    # stream = p.open(format=p.get_format_from_width(2),
    #                 channels=num_channels,
    #                 rate=fs,
    #                 output=True)
    #
    # # play stream (3), blocking call
    #
    # stream.write(raw_input)
    #
    # # stop stream (4)
    # stream.stop_stream()
    # stream.close()
    #
    # # close PyAudio (5)
    # p.terminate()
