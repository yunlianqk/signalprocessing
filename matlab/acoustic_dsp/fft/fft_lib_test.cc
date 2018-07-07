// Copyright 2015 Mobvoi Inc. All Rights Reserved.
// Author: liqiang@mobvoi.com (Qiang Li)
// Created on: November 4, 2015

#if defined(__ARM_NEON__) && defined(ANDROID_L_OR_LOWER)
#include "mobvoi/fft/ne10_fft.h"
#endif
#include "mobvoi/fft/srfft.h"

#include <numeric>
#include "engine/frontend/feature_extraction_util.h"
#include "mobvoi/fft/matrix-functions.h"
#include "mobvoi/base/log.h"
#include "mobvoi/base/test_utils.h"
#include "mobvoi/matrix/matrix_test_utils.h"
#include "mobvoi/util/kaldi-io.h"
#include "mobvoi/util/kaldi-math.h"
#include "mobvoi/util/timer.h"

using kaldi::Input;
using kaldi::MatrixIndexT;
using kaldi::SplitRadixRealFft;
using kaldi::Vector;

namespace mobvoi {

Vector<float> input_test_vector;
Vector<float> fft_baseline_test_vector;
Vector<float> ifft_baseline_test_vector;

static void LoadTestVectors() {
  const string input_file = "engine/matrix/testdata/fft.test.in";
  LoadVector(input_file, &input_test_vector);

  const string fft_file = "engine/matrix/testdata/fft.test.out";
  LoadVector(fft_file, &fft_baseline_test_vector);

  const string ifft_file = "engine/matrix/testdata/ifft.test.out";
  LoadVector(ifft_file, &ifft_baseline_test_vector);
}

static void UnitTestRealFftInefficient() {
  MatrixIndexT N = input_test_vector.Dim();
  Vector<float> fft_vector(N);
  fft_vector.CopyFromVec(input_test_vector);

  RealFftInefficient(&fft_vector, true);
  if (!ExpectVectorEqual(fft_baseline_test_vector, fft_vector, 0.001 * N)) {
    LOG(FATAL) << "Inefficient forward real fft tests fail!";
  }

  RealFftInefficient(&fft_vector, false);
  if (!ExpectVectorEqual(ifft_baseline_test_vector, fft_vector, 0.001 * N)) {
    LOG(FATAL) << "Inefficient inverse real fft tests fail!";
  }
}

static void UnitTestSplitRadixRealFft() {
  MatrixIndexT dim = input_test_vector.Dim();
  Vector<float> test_vector(dim);
  test_vector.CopyFromVec(input_test_vector);

  SplitRadixRealFft<float> sr(dim);
  sr.Compute(test_vector.Data(), true);
  if (!ExpectVectorEqual(fft_baseline_test_vector, test_vector, 0.001 * dim)) {
    LOG(FATAL) << "split radix forward real fft tests fail!";
  }

  sr.Compute(test_vector.Data(), false);
  if (!ExpectVectorEqual(ifft_baseline_test_vector, test_vector, 0.001 * dim)) {
    LOG(FATAL) << "split radix inverse real fft tests fail!";
  }
}

static void FullTestSplitRadixRealFft() {
  for (MatrixIndexT p = 0; p < 30; ++p) {
    MatrixIndexT logn = 3 + rand() % 10;
    MatrixIndexT N = 1 << logn;
    SplitRadixRealFft<float> srfft(N);

    for (MatrixIndexT q = 0; q < 3; ++q) {
      Vector<float> orig_vector(N);
      Vector<float> baseline_vector(N);
      Vector<float> fft_vector(N);
      orig_vector.SetRandn();

      baseline_vector.CopyFromVec(orig_vector);
      RealFftInefficient(&baseline_vector, true);
      fft_vector.CopyFromVec(orig_vector);
      srfft.Compute(fft_vector.Data(), true);
      if (!ExpectVectorEqual(baseline_vector, fft_vector, 0.001 * N)) {
        LOG(FATAL) << "split radix forward real fft tests fail!";
      }

      baseline_vector.CopyFromVec(fft_vector);
      RealFftInefficient(&baseline_vector, false);
      srfft.Compute(fft_vector.Data(), false);
      if (!ExpectVectorEqual(baseline_vector, fft_vector, 0.001 * N)) {
        LOG(FATAL) << "split radix inverse real fft tests fail!";
      }
    }
  }
}

#if defined(__ARM_NEON__) && defined(ANDROID_L_OR_LOWER)
static void UnitTestNe10RealFft() {
  MatrixIndexT dim = input_test_vector.Dim();
  Vector<float> test_vector(dim);
  test_vector.CopyFromVec(input_test_vector);

  Ne10RealFft<float> ne(dim);
  ne.Compute(test_vector.Data(), true);
  if (!ExpectVectorEqual(fft_baseline_test_vector, test_vector, 0.001 * dim)) {
    LOG(FATAL) << "ne10 forward real fft tests fail!";
  }

  ne.Compute(test_vector.Data(), false);
  if (!ExpectVectorEqual(ifft_baseline_test_vector, test_vector, 0.001 * dim)) {
    LOG(FATAL) << "ne10 inverse real fft tests fail!";
  }
}

static void FullTestNe10RealFft() {
  for (MatrixIndexT p = 0; p < 30; ++p) {
    MatrixIndexT logn = 3 + rand() % 10;
    MatrixIndexT N = 1 << logn;
    Ne10RealFft<float> nefft(N);

    for (MatrixIndexT q = 0; q < 3; ++q) {
      Vector<float> orig_vector(N);
      Vector<float> baseline_vector(N);
      Vector<float> fft_vector(N);
      orig_vector.SetRandn();

      baseline_vector.CopyFromVec(orig_vector);
      RealFftInefficient(&baseline_vector, true);
      fft_vector.CopyFromVec(orig_vector);
      nefft.Compute(fft_vector.Data(), true);
      if (!ExpectVectorEqual(baseline_vector, fft_vector, 0.001 * N)) {
        LOG(FATAL) << "ne10 forward real fft tests fail";
      }

      baseline_vector.CopyFromVec(fft_vector);
      RealFftInefficient(&baseline_vector, false);
      nefft.Compute(fft_vector.Data(), false);
      if (!ExpectVectorEqual(baseline_vector, fft_vector, 0.001 * N)) {
        LOG(FATAL) << "ne10 inverse real fft tests fail";
      }
    }
  }
}
#endif

static void SplitRadixRealFftSpeedTest(int fft_size, int iter_times) {
  SplitRadixRealFft<float> srfft(fft_size);
  kaldi::Timer timer;
  for (int i = 0; i < iter_times; ++i) {
    Vector<float> v(fft_size);
    srfft.Compute(v.Data(), true);
  }
  LOG(INFO) << "SplitRadix real fft " << iter_times << " times take "
            << timer.Elapsed() << " sec." << std::endl;
}

#if defined(__ARM_NEON__) && defined(ANDROID_L_OR_LOWER)
static void Ne10RealFftSpeedTest(int fft_size, int iter_times) {
  Ne10RealFft<float> nefft(fft_size);
  kaldi::Timer timer;
  for (int i = 0; i < iter_times; ++i) {
    Vector<float> v(fft_size);
    nefft.Compute(v.Data(), true);
  }
  LOG(INFO) << "NE10 NEON version real fft " << iter_times << " times take "
            << timer.Elapsed() << " sec." << std::endl;
}
#endif

}  // namespace mobvoi

int main() {
  using namespace mobvoi;

  LoadTestVectors();

  UnitTestRealFftInefficient();
  UnitTestSplitRadixRealFft();
  FullTestSplitRadixRealFft();
#if defined(__ARM_NEON__) && defined(ANDROID_L_OR_LOWER)
  UnitTestNe10RealFft();
  FullTestNe10RealFft();
#endif

  SplitRadixRealFftSpeedTest(512, 10000);
#if defined(__ARM_NEON__) && defined(ANDROID_L_OR_LOWER)
  Ne10RealFftSpeedTest(512, 10000);
#endif
}
