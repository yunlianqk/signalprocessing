// Copyright 2015 Mobvoi Inc. All Rights Reserved.
// Author: liqiang@mobvoi.com (Qiang Li)
// Created on: November 3, 2015

#if defined(USE_NEONFFT)

#include "mobvoi/fft/ne10_fft.h"

#include "mobvoi/base/log.h"

namespace mobvoi {

template<typename Real>
Ne10RealFft<Real>::Ne10RealFft(Integer N) : N_(N) {
  // TODO(liqiang): there are some issues for computation of size 4
  CHECK((N & (N - 1)) == 0 && N >= 8);

  config_ = ne10_fft_alloc_r2c_float32(static_cast<ne10_int32_t>(N_));
  real_data_ = (ne10_float32_t*) NE10_MALLOC(N_ * sizeof(ne10_float32_t));
  complex_data_ = (ne10_fft_cpx_float32_t*) NE10_MALLOC(N_ * sizeof(ne10_fft_cpx_float32_t));
}

template<typename Real>
Ne10RealFft<Real>::~Ne10RealFft() {
  NE10_FREE(real_data_);
  NE10_FREE(complex_data_);
  NE10_FREE(config_);
}

template<typename Real>
void Ne10RealFft<Real>::Compute(Real* x, bool forward) {
  if (forward) {
    for (int i = 0; i < N_; ++i) {
      real_data_[i] = x[i];
    }
    ne10_fft_r2c_1d_float32_neon(complex_data_, real_data_, config_);
    x[0] = complex_data_[0].r;
    x[1] = complex_data_[N_ / 2].r;
    for (int i = 1; i < N_ / 2; ++i) {
      x[2 * i] = complex_data_[i].r;
      x[2 * i + 1] = complex_data_[i].i;
    }
  } else {
    complex_data_[0].r = x[0];
    complex_data_[N_ / 2].r = x[1];
    for (int i = 1; i < N_ / 2; ++i) {
      complex_data_[i].r = x[2 * i];
      complex_data_[i].i = x[2 * i + 1];
      complex_data_[N_ - i].r = x[2 * i];
      complex_data_[N_ - i].i = - x[2 * i + 1];
    }
    ne10_fft_c2r_1d_float32_neon(real_data_, complex_data_, config_);
    for (int i = 0; i < N_; ++i) {
      x[i] = real_data_[i] * N_;
    }
  }
}

template class Ne10RealFft<float>;
template class Ne10RealFft<double>;

}  // namespace mobvoi

#endif  // defined(USE_NEONFFT)
