import pyaudio
import webrtcvad
import numpy as np
import collections
import Queue
import threading
import signal
import sys
import math
import audioop
from GCC_PHAT_Test import gcc_phat
from vad import vad


class Microphone:
    def __init__(self, rate=16000, channels=2):
        self.pyaudio_instance = pyaudio.PyAudio()
        self.queue = Queue.Queue()
        self.quit_event = threading.Event()
        self.channels = channels
        self.sample_rate = rate

    def _callback(self, in_data, frame_count, time_info, status):
        self.queue.put(in_data)
        return None, pyaudio.paContinue

    def read_chunks(self, size):
        device_index = None
        # for i in range(self.pyaudio_instance.get_device_count()):
        #     dev = self.pyaudio_instance.get_device_info_by_index(i)
        #     name = dev['name'].encode('utf-8')
        #     print(i, name, dev['maxInputChannels'], dev['maxOutputChannels'])
        #     if dev['maxInputChannels'] >= self.channels:
        #         print('Use {}'.format(name))
        #         device_index = i
        #         break

        # if not device_index:
        #     print('can not find input device with {} channel(s)'.format(self.channels))
        #     return

        stream = self.pyaudio_instance.open(
            input=True,
            format=pyaudio.paInt16,
            channels=self.channels,
            rate=self.sample_rate,
            frames_per_buffer=size,
            stream_callback=self._callback,
            input_device_index=device_index,
        )

        while not self.quit_event.is_set():
            frames = self.queue.get()
            if not frames:
                break
            yield frames

        stream.close()

    def close(self):
        self.quit_event.set()
        self.queue.put('')


def main():
    sample_rate = 48000
    channels = 2
    N = 4096 * 4

    mic = Microphone(sample_rate, channels)
    window = np.hanning(N)

    sound_speed = 343.2
    distance = 0.10

    max_tau = distance / sound_speed

    def signal_handler(sig, num):
        print('Quit')
        mic.close()

    signal.signal(signal.SIGINT, signal_handler)

    for data in mic.read_chunks(N):
        buf = np.fromstring(data, dtype='int16')
        mono = buf[0::channels].tostring()
        if sample_rate != 16000:
            mono, _ = audioop.ratecv(mono, 2, 1, sample_rate, 16000, None)
            print mono

        if vad.is_speech(mono):
            tau = gcc_phat(buf[0::channels] * window, buf[1::channels] * window, fs=sample_rate, max_tau=max_tau)
            theta = math.asin(tau / max_tau) * 180 / math.pi
            print('\ntheta: {}'.format(int(theta)))


if __name__ == '__main__':
    main()