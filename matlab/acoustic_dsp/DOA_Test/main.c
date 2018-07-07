#include <stdio.h>
#include <stdlib.h>
#include "wavProcess.h"
#include "gcc_phat.h"

int main() {

    printf("Hello, welcome to the DOA algorithm validation!\n\n");


    int16_t *samples = NULL;
    double *ins_mic = NULL;        /**< inside microphone is close to the mid point of Ticmirror*/
    double *out_mic = NULL;        /**< outside microphone is close to the edge of Ticmirror */


    /*
     * Feel free to assess your .wav file, and the file must have a 2-channel signal.
     */
    wavread("/home/mobvoi/PycharmProjects/acoustic_dsp/BSS/Recording/DOA_-90to90_degrees_moving.wav", &samples);


    unsigned int data_size = (header->datachunk_size)/2;


    ins_mic = (double *)malloc(data_size*sizeof(double));
    out_mic = (double *)malloc(data_size*sizeof(double));


    printf("No. of channels: %d\n", header->num_channels);
    printf("Sample rate:     %d\n", header->sample_rate);
    printf("Bit rate:        %dkbps\n", header->byte_rate*8 / 1000);
    printf("Bits per sample: %d\n", header->bps);
    printf("Data chunk size: %d\n\n", data_size*2);
    printf("\n");


    /*
     * Data stored in .wav file are interleaved. Channel 1 and 2 are stored one following the other.
     */
    for (int i = 0; i < data_size-1 ; i+=2) {
        ins_mic[i/2] = samples[i];
        out_mic[i/2] = samples[i+1];
    }


    printf("\n");
    /*
     *  Process the Direction of Arrival algorithm
     */

    DOA(ins_mic, out_mic, data_size/2, header->sample_rate);


    return 0;
}

