// Copyright 2014 Mobvoi Inc. All Rights Reserved.
// Author: jsliu@mobvoi.com (Junshi Liu)
// Created on: Oct 28, 2014

#pragma once

#include "mobvoi/base/mutex.h"
#include "mobvoi/base/log.h"
#include "mobvoi/fft/fftw3.h"

#include "mobvoi/matrix/matrix-common.h"

namespace mobvoi {

typedef kaldi::MatrixIndexT Integer;

extern mobvoi::Mutex g_fftw_mutex;

// This algorithm is on web: www.fftw.org
// Edition version: 3.3.4 with public license
// Mostly targeted to be used in Kaldi FFT
// Data size: 512 real 1D FFT
template<typename Real>
class FftwRealFft {
 public:
  FftwRealFft(Integer n, bool forward);
  ~FftwRealFft();

  void Compute(Real* window) const;

 private:
  Integer n_;
  fftwf_complex* fft_in;
  fftwf_complex* fft_out;
  fftwf_plan plan;
};

template<typename Real>
FftwRealFft<Real>::FftwRealFft(Integer n, bool forward) : n_(n) {
  DCHECK(n_ > 0 && n_ % 2 == 0);
  fft_in = (fftwf_complex*) fftwf_malloc(sizeof(fftwf_complex) * n_);
  fft_out = (fftwf_complex*) fftwf_malloc(sizeof(fftwf_complex) * n_);
  {
    mobvoi::MutexLock lock(&g_fftw_mutex);
    if (forward) {
      plan = fftwf_plan_dft_1d(n_, fft_in, fft_out, FFTW_FORWARD, FFTW_ESTIMATE);
    } else {
      plan = fftwf_plan_dft_1d(n_, fft_in, fft_out, FFTW_BACKWARD, FFTW_ESTIMATE);
    }
  }
}

template<typename Real>
FftwRealFft<Real>::~FftwRealFft() {
  {
    mobvoi::MutexLock lock(&g_fftw_mutex);
    fftwf_destroy_plan(plan);
  }
  fftwf_free(fft_in);
  fftwf_free(fft_out);
}

template<typename Real>
void FftwRealFft<Real>::Compute(Real* window) const {
  // Get data from Kaldi complex type to FFTW type
  for (int i = 0;i < n_; ++i) {
    fft_in[i][0] = static_cast<float>(window[i]);
    fft_in[i][1] = static_cast<float>(0.0f);
  }

  fftwf_execute(plan);

  // Write data back to fit Kaldi complex type
  for(int i = 0; i < n_ / 2; ++i) {
    window[2 * i] = fft_out[i][0];
    window[2 * i + 1] = fft_out[i][1];
  }
}

}  // namespace mobvoi
