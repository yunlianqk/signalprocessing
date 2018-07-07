// Copyright 2014 Mobvoi Inc. All Rights Reserved.
// Author: jsliu@mobvoi.com (Junshi Liu)
// Created on: Oct 28, 2014

#if !defined(USE_NEONFFT) && !defined(USE_SRFFT)

#include "mobvoi/fft/fftw_wrapper.h"

namespace mobvoi {

mobvoi::Mutex g_fftw_mutex;

}  // namespace mobvoi

#endif  // !defined(USE_NEONFFT) && !defined(USE_SRFFT)
