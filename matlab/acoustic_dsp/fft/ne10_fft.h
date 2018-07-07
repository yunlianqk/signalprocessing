// Copyright 2015 Mobvoi Inc. All Rights Reserved.
// Author: liqiang@mobvoi.com (Qiang Li)
// Created on: November 3, 2015

#ifndef MOBVOI_FFT_NE10_FFT_H_
#define MOBVOI_FFT_NE10_FFT_H_

#include "mobvoi/matrix/matrix-common.h"
#include "third_party/ne10/inc/NE10.h"

namespace mobvoi {

template<typename Real>
class Ne10RealFft {
 public:
  typedef kaldi::MatrixIndexT Integer;

  explicit Ne10RealFft(Integer N);
  ~Ne10RealFft();

  // In order to keep the data format compatible with the real fft in kaldi,
  // the interpretation of the complex-FFT data is as follows: the array
  // is a sequence of complex numbers C_n of length N / 2 with (real, imagin) format,
  // i.e. [real0, real_{N / 2}, real1, imagin1, real2, imagin2, real3, imagin3, ...].
  // If you call it in the forward and then reverse direction and multiply
  // by 1.0 / N, you will get back the original data.
  void Compute(Real* x, bool forward);

 private:
  Integer N_;
  ne10_fft_r2c_cfg_float32_t config_;
  ne10_float32_t* real_data_;
  ne10_fft_cpx_float32_t* complex_data_;
};

}  // namespace mobvoi

#endif  // MOBVOI_FFT_NE10_FFT_H_
