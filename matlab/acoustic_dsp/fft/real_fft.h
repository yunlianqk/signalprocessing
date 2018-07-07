// Copyright 2015 Mobvoi Inc. All Rights Reserved.
// Author: liqiang@mobvoi.com (Qiang Li)
// Created on: November 6, 2015

#ifndef MOBVOI_FFT_REAL_FFT_H_
#define MOBVOI_FFT_REAL_FFT_H_

#if defined(USE_NE10FFT) && defined(USE_SRFFT)
#error "Do not define more than one of USE_NE10_FFT, USE_SRFFT"
#endif

#if defined(USE_NE10FFT)
#include "mobvoi/fft/ne10_fft.h"
#elif defined(USE_SRFFT)
#include "mobvoi/fft/srfft.h"
#else
#include "mobvoi/fft/fftw_wrapper.h"
#endif

namespace mobvoi {

// This class conducts the forward FFT from real to complex, or the inverse FFT
// according to the 'forward' flag. It can choose the appropriate efficient
// implementation for different hardware arch., e.g. Ne10 for ARM with NEON.
template<typename Real>
class RealFft {
 public:
  typedef kaldi::MatrixIndexT Integer;

  RealFft(Integer N, bool forward);

  void Compute(Real *x);
 
 private:
  bool forward_;

#if defined(USE_NE10FFT)
  std::unique_ptr<mobvoi::Ne10RealFft<Real> > ne10_fft_;
#elif defined(USE_SRFFT)
  std::unique_ptr<kaldi::SplitRadixRealFft<Real> > srfft_;
#else
  std::unique_ptr<mobvoi::FftwRealFft<Real> > fftw_fft_;
#endif

  DISALLOW_COPY_AND_ASSIGN(RealFft);
};

template<typename Real>
RealFft<Real>::RealFft(Integer N, bool forward) : forward_(forward) {
#if defined(USE_NE10FFT)
  ne10_fft_.reset(new mobvoi::Ne10RealFft<Real>(N));
#elif defined(USE_SRFFT)
  srfft_.reset(new kaldi::SplitRadixRealFft<Real>(N));
#else
  fftw_fft_.reset(new mobvoi::FftwRealFft<Real>(N, forward));
#endif
}

template<typename Real>
void RealFft<Real>::Compute(Real* x) {
#if defined(USE_NE10FFT)
  ne10_fft_->Compute(x, forward_);
#elif defined(USE_SRFFT)
  srfft_->Compute(x, forward_);
#else
  fftw_fft_->Compute(x);
#endif
}

}  // namespace mobvoi

#endif
