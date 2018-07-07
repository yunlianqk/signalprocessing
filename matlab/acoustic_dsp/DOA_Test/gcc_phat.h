//
// Created by mobvoi on 17-4-10.
//

#ifndef DOA_TEST_GCC_PHAT_H
#define DOA_TEST_GCC_PHAT_H


#include <string.h>
#include <assert.h>
#include <stdlib.h>
#include <stdbool.h>
#include <math.h>
#include <float.h>
#include <complex.h>
#include "fftw3.h"



double DOA(double* const ins_mic, double* const out_mic, unsigned int data_size, unsigned int fs);

void _gcc_setup(const unsigned N);

void _max_index(const double* const a, const unsigned N, double* const max, unsigned* const maxi);

void _gcc(const double* const siga, const double* const sigb, const unsigned N, const double interp,
          const double max_tau, unsigned* max_shift);

void xcorr_shift(const double* xcorr, double* shifted_corr, double max_tau, unsigned interp, const double fs,
                 const unsigned N, unsigned* max_shift);

double _get_time_diff(const double* siga, const double* sigb, const unsigned N,
              const unsigned interp, const double max_tau, const unsigned fs);

#endif //DOA_TEST_GCC_PHAT_H
