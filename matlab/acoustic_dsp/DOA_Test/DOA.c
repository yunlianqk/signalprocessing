//
// Created by mobvoi on 17-4-6.
//
#include <stdio.h>
#include "gcc_phat.h"


static unsigned      _N = 0;        /**< size of input vector */

extern double * local_siga;          /**< local copy of input A */
extern double * local_sigb;          /**< local copy of input B */

extern fftw_plan pa;                 /**< FFTW plan for FFT(A) */
extern fftw_plan pb;                 /**< FFTW plan for FFT(B) */
extern fftw_plan px;                 /**< FFTW plan for IFFT(xspec) */
extern fftw_complex* ffta;           /**< fft of input A */
extern fftw_complex* fftb;           /**< fft of input B */
extern fftw_complex* xspec;          /**< the cross-spectrum of A & B */
extern double * xcorr;               /**< the cross-correlation of A & B */


double DOA(double* const ins_mic, double* const out_mic, unsigned int data_size, unsigned int fs){

    /*
     *  This function computes the offset between two microphones using
     *  GCC-PHAT method
     */

    unsigned int fresh_window = fs;              /*Currently use a fresh_window that is of the same size as sampling freq*/
    unsigned int step_size = fresh_window /2;    /*Each time move the window half of the fresh_window size*/
    unsigned int interp = 4;                    /*TODO: The interpolation factor is crucial, needs tuning!!! */
    double max_tau = 0.045 / 343;                /*Mic distance 4.5cm, speech of sound 343m/s */



    /* Sample size is 1 sec */
    unsigned int N = fs;


    for (int i =16000; i < 20000; i += step_size) {
//        printf("%d--%d  ", i, i+fs);
        printf("%d - %d \n", i, i+N);


        double delay = _get_time_diff(&ins_mic[i], &out_mic[i], N, interp, max_tau, fs);
        printf("Delay is: %f \n", delay);

        double theta = asin(delay/max_tau) * 180 / M_PI;
        printf("Theta is: %f \n\n", theta);
    }

    printf("DOA Done");

}

