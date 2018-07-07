// fft/matrix-functions.h

// Copyright 2009-2011  Microsoft Corporation;  Go Vivace Inc.;  Jan Silovsky;
//                      Yanmin Qian;   1991 Henrique (Rico) Malvar (*)
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//  http://www.apache.org/licenses/LICENSE-2.0
//
// THIS CODE IS PROVIDED *AS IS* BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
// KIND, EITHER EXPRESS OR IMPLIED, INCLUDING WITHOUT LIMITATION ANY IMPLIED
// WARRANTIES OR CONDITIONS OF TITLE, FITNESS FOR A PARTICULAR PURPOSE,
// MERCHANTABLITY OR NON-INFRINGEMENT.
// See the Apache 2 License for the specific language governing permissions and
// limitations under the License.
//
// (*) incorporates, with permission, FFT code from his book
// "Signal Processing with Lapped Transforms", Artech, 1992.



#ifndef MOBVOI_FFT_MATRIX_FUNCTIONS_H_
#define MOBVOI_FFT_MATRIX_FUNCTIONS_H_

#include "mobvoi/fft/matrix-functions-inl.h"
#include "mobvoi/matrix/kaldi-vector.h"
#include "mobvoi/matrix/kaldi-matrix.h"

namespace kaldi {

/// @addtogroup matrix_funcs_misc
/// @{

/** The function ComplexFft does an Fft on the vector argument v.
   v is a vector of even dimension, interpreted for both input
   and output as a vector of complex numbers i.e.
   \f[ v = ( re_0, im_0, re_1, im_1, ... )    \f]
   The dimension of v must be a power of 2.

   If "forward == true" this routine does the Discrete Fourier Transform
   (DFT), i.e.:
   \f[   vout[m] \leftarrow \sum_{n = 0}^{N-1} vin[i] exp( -2pi m n / N )  \f]

   If "backward" it does the Inverse Discrete Fourier Transform (IDFT)
   *WITHOUT THE FACTOR 1/N*,
   i.e.:
   \f[   vout[m] <-- \sum_{n = 0}^{N-1} vin[i] exp(  2pi m n / N )   \f]
   [note the sign difference on the 2 pi for the backward one.]

   Note that this is the definition of the FT given in most texts, but
   it differs from the Numerical Recipes version in which the forward
   and backward algorithms are flipped.

   Note that you would have to multiply by 1/N after the IDFT to get
   back to where you started from.  We don't do this because
   in some contexts, the transform is made symmetric by multiplying
   by sqrt(N) in both passes.   The user can do this by themselves.
 */
template<class Real> void ComplexFft(VectorBase<Real> *v, bool forward, Vector<Real> *tmp_work = NULL);

/// ComplexFft is the same as ComplexFft but it implements the Fourier
/// transform in an inefficient way.  It is mainly included for testing purposes.
/// See comment for ComplexFft to describe the input and outputs and what it does.
template<class Real> void ComplexFft(const VectorBase<Real> &in,
                                     VectorBase<Real> *out, bool forward);

/// RealFft is a fourier transform of real inputs.  Internally it uses
/// ComplexFft.  The input dimension N must be even.  If forward == true,
/// it transforms from a sequence of N real points to its complex fourier
/// transform; otherwise it goes in the reverse direction.  If you call it
/// in the forward and then reverse direction and multiply by 1.0/N, you
/// will get back the original data.
/// The interpretation of the complex-FFT data is as follows: the array
/// is a sequence of complex numbers C_n of length N/2 with (real, im) format,
/// i.e. [real0, real_{N/2}, real1, im1, real2, im2, real3, im3, ...].
template<class Real> void RealFft(VectorBase<Real> *v, bool forward);

/// RealFt has the same input and output format as RealFft above, but it is
/// an inefficient implementation included for testing purposes.
template<class Real> void RealFftInefficient(VectorBase<Real> *v, bool forward);

/// ComplexMul implements, inline, the complex multiplication b *= a.
template<class Real> inline void ComplexMul(const Real &a_re, const Real &a_im,
                                            Real *b_re, Real *b_im);

/// ComplexMul implements, inline, the complex operation c += (a * b).
template<class Real> inline void ComplexAddProduct(const Real &a_re, const Real &a_im,
                                                   const Real &b_re, const Real &b_im,
                                                   Real *c_re, Real *c_im);

// ComputeDctMatrix computes a matrix corresponding to the DCT, such that
// M * v equals the DCT of vector v.  M must be square at input.
// This is the type = III DCT with normalization, corresponding to the
// following equations, where x is the signal and X is the DCT:
// X_0 = 1/sqrt(2*N) \sum_{n = 0}^{N-1} x_n
// X_k = 1/sqrt(N) \sum_{n = 0}^{N-1} x_n cos( \pi/N (n + 1/2) k )
// This matrix's transpose is its own inverse, so transposing this
// matrix will give the inverse DCT.
// Caution: the type III DCT is generally known as the "inverse DCT" (with the
// type II being the actual DCT), so this function is somewhatd mis-named.  It
// was probably done this way for HTK compatibility.  We don't change it
// because it was this way from the start and changing it would affect the
// feature generation.
template<class Real> void ComputeDctMatrix(Matrix<Real>* M);

} // end namespace kaldi

#endif

