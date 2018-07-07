# Copyright 2016 Mobvoi Inc. All Rights Reserved.
# Author: cfyeh@mobvoi.com (Ching-Feng Yeh)

package(default_visibility = ['//visibility:public'])

load("//mobvoi:build_defs.bzl", "mobvoi_cc_library")

mobvoi_cc_library(
    name = 'fft',
    srcs = [
        'fftw_wrapper.cc',
        'matrix-functions.cc',
        'ne10_fft.cc',
        'srfft.cc',
    ],
    hdrs = [
        'fftw3.h',
        'fftw_wrapper.h',
        'matrix-functions.h',
        'matrix-functions-inl.h',
        'ne10_fft.h',
        'real_fft.h',
        'srfft.h',
    ],
    deps = [
        '//mobvoi/matrix:matrix',
        '//third_party/fftw:fftw3f',
        '//third_party/mkl:mkl_rt',
    ],
)
