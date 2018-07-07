/**
 * @file gcc_phat.c GCC-PHAT for signal offset calculation
 * @brief
 * @authorShuran Zhou <shrzhou@mobvoi.com>, Chuck Wooters <wooters@icsi.berkeley.edu>
 * @copyright 2013 International Computer Science Institute
 */

#include "gcc_phat.h"


static unsigned      _N = 0;         /**< size of input vector */
double* local_siga = NULL;           /**< local copy of input A */
double* local_sigb = NULL;           /**< local copy of input B */

fftw_complex* ffta  = NULL;          /**< fft output of input A */
fftw_complex* fftb  = NULL;          /**< fft output of input B */
fftw_complex* xspec = NULL;          /**< the cross-spectrum of A & B */

fftw_plan pa = NULL;                 /**< FFTW plan for FFT(A) */
fftw_plan pb = NULL;                 /**< FFTW plan for FFT(B) */
fftw_plan px = NULL;                 /**< FFTW plan for IFFT(xspec) */


double * xcorr = NULL;               /**< the cross-correlation of A & B */
double* shifted_xcorr = NULL;        /**< shifted version of cross-correlation */


/*
 * Find the index and max value in the given array of doubles.
 */
void _max_index(const double* const a, const unsigned N,
                double* const max, unsigned* const maxi) {
    assert(a!=NULL);

    if (N <= 1) {
        *max = a[0]; *maxi = 0;
    } else {
        unsigned maxi_t = 0;
        double max_t = a[0];
        for (unsigned i=1;i<N;i++){
            if (cabs(a[i]) > max_t) {
                max_t = a[i]; maxi_t = i;
            }
        }
        *max = max_t;
        *maxi = maxi_t;
    }
}

/*
 * Shift the values in xcorr[] so that the last _max_shift elements of xcorr[] are at the first part of shifted_corr[]
 * and the first _max_shift elements of xcorr[] are at the last part of shifted_corr[], tha _max_shift elements need to
 * be tunning for identifing the best phase shift.
 */

void xcorr_shift(const double* xcorr, double* shifted_corr, const double max_tau, const unsigned interp, const double fs,
                 const unsigned N, unsigned* max_shift) {

    unsigned int local_max_shift = interp * 2 * 16000 / 2;

    local_max_shift = interp * fs * max_tau < local_max_shift ? interp * fs * max_tau : local_max_shift;

    *max_shift = local_max_shift;

    /* Copy last _max_shift elements of xcorr[] to first part of shifted_corr[] */
    memcpy(shifted_corr,&xcorr[interp*2*N-local_max_shift],sizeof(double)*(local_max_shift));

    /* Copy first max_shift+1 elements of xcorr[] to end of shifted_corr[] */
    memcpy(&shifted_corr[local_max_shift],xcorr,sizeof(double)*(local_max_shift+1));
}


/*
 * Compute the dot product of two vectors a & b, each of length N.
 */
double _dot_product(const double* const a, const double* const b, const unsigned N) {
    double d = 0.0;
    for (unsigned i=0;i<N;i++) d += a[i]*b[i];
    return d;
}


/*
 * Compute the energy of the given signal. This is for a simple VAD
 */
double _energy_calc(const double* const a, const unsigned N) {
    assert(a!=NULL);
    if (N==1) return a[0]*a[0];
    return _dot_product(a,a,N);
}

/*
 * Free up memory allocated for doing GCC
 */
void _xcorr_free() {
    if (xspec)      fftw_free(xspec);
    if (fftb)       fftw_free(fftb);
    if (ffta)       fftw_free(ffta);
    if (xcorr)      free(xcorr);
    if (local_sigb) free(local_sigb);
    if (local_siga) free(local_siga);

}

/*
 * Allocate memory for running GCC functions
 */
void _xcorr_malloc() {

    local_siga       =(double*)calloc(2*_N, sizeof(double));        //for interpolation
    local_sigb       =(double*)calloc(2*_N, sizeof(double));        //for interpolation
    xcorr            =(double*)calloc(4*2*_N, sizeof(double));        //for interpolation
    shifted_xcorr    =(double*)calloc(_N, sizeof(double));

    ffta         = fftw_alloc_complex(_N);
    fftb         = fftw_alloc_complex(_N);
    xspec        = fftw_alloc_complex(_N);

}

/*
 * Clean-up when finished running GCC.
 */
void _xcorr_teardown() {
    if (pa) fftw_destroy_plan(pa);
    if (pb) fftw_destroy_plan(pb);
    if (px) fftw_destroy_plan(px);
    _xcorr_free();
    fftw_cleanup();
}

/*
 * Prepare for running GCC.
 */
void _xcorr_setup() {

    _xcorr_teardown();
    _xcorr_malloc();

    pa = fftw_plan_dft_r2c_1d(2*_N, local_siga, ffta,  FFTW_ESTIMATE|FFTW_DESTROY_INPUT); //interpolation with 2*N
    pb = fftw_plan_dft_r2c_1d(2*_N, local_sigb, fftb,  FFTW_ESTIMATE|FFTW_DESTROY_INPUT); //interpolation with 2*N
    px = fftw_plan_dft_c2r_1d(4*2*_N, xspec, xcorr, FFTW_ESTIMATE|FFTW_DESTROY_INPUT);      //ifft shape is also 2*N

}

/**
 * Determine if we need to run xcorr_setup()
 */
void _gcc_setup(const unsigned N) {
    if (_N != N) {      /* do we need a new vector size? */
                        /* update static variables */
        _N = N;
        _xcorr_setup();        /* set up the static vectors and FFT params */
    }
}

/**
 * Perform generalized cross-correlation. This function performs a
 * generalized cross-correlation (GCC) between two input vectors using
 * a specified weighting funciton and fills an output array with
 * cross-correlation values.
 *
 * @param siga first signal of doubles
 * @param sigb second signal of doubles
 * @param N length of both signals
 * @param max_shift
 *
 * @see _get_time_diff()
 *
 */
void _gcc(const double* siga, const double* sigb, const unsigned N, const double interp, const double max_tau, unsigned* max_shift)
{
    _gcc_setup(N);

    /* copy the input arrays into the local arrays */
    memcpy(local_siga,siga,_N*sizeof(double));
    memcpy(local_sigb,sigb,_N*sizeof(double));

    for (int i = 0; i < 20 ; ++i) {
        printf("%f ", siga[i]);
    }

    printf("\n");

    for (int i = 0; i < 20 ; ++i) {
        printf("%f ", sigb[i]);
    }
//
    printf("\n");

    /* Perform the FFTs on the two input signals.
     *   The output will be stored in ffta[] and fftb[]. These
     *   are arrays of complex numbers and will contain only
     *   the non-negative frequencies, plus one element.
     */


    fftw_execute(pa);
    fftw_execute(pb);

    printf("ffta: \n");
    for(unsigned i = 0; i<N+1; i++) {
        printf("%f + %fi ", creal(ffta[i]), cimag(ffta[i]));
    }



    printf("\nfftb: \n");
    for(unsigned i = 0; i<N+1; i++) {
        printf("%f + %fi ", creal(fftb[i]), cimag(fftb[i]));
    }

    printf("\n\n");


    /* Note that we only need to loop over the first _N/2+1 items
     * in ffta[] and fft[b] since the remainder of the items
     * are all 0's (FFTW only computes the non-negative frequencies
     * for real-input FFTs).
     */
    unsigned xspec_bound = interp*N+1;




    for (unsigned i = 0; i < xspec_bound; i++) {
        fftw_complex tmp = ffta[i] * conj(fftb[i]); /* cross-spectra */
//        fftw_complex tp= creal(ffta[i])*creal(fftb[i]);
//        printf("tmp: %f + %fi \n", creal(tmp), cimag(tmp));
//        printf("tmp: %f + %fi \n", creal(cabs(tmp)), cimag(cabs(tmp)));
//
        xspec[i] = tmp/(cabs(tmp) + DBL_MIN); /* adding DBL_MIN to prevent div by 0 */
//        printf("xspec[]: %f + %fi \n", creal(xspec[i]) , cimag(xspec[i]));

    }


    /* Inverse Fourier transform of the cross-spectra. Output will be placed in xcorr[] */
    fftw_execute(px);


    /*
    * Normalization ->
    * Be very carefull that the iFFT output needs a normalization of the length of the array.
    */
    for (int i = 0; i < interp*2*N ; ++i) {
        xcorr[i] = xcorr[i] / (interp*2*N);
    }

//    printf("check: %f + %fi\n", creal(fftb[49151]), cimag(fftb[49151]));

    printf("cross-correlation: \n");

    for(int i= interp*2*N -8  ;i< interp*2*N; i++){
        printf("%f ", xcorr[i]);
    }

    printf("\n");

    for(int i=0;i< 8;i++){
        printf("%f ", xcorr[i]);
    }
    printf("\n");


    /*
    * Shift the values in xcorr[]
    * the output array.
    * [Note: the index of the center value in the output will be: ceil(_N/2) ]
    */

    xcorr_shift(xcorr, shifted_xcorr, max_tau, interp, N, N, max_shift);

    printf("\nshifted cross-correlation: \n");
    for(int i=0;i<17;i++){
        printf("%f ", shifted_xcorr[i]);
    }
    printf("\n");
}

double _get_time_diff(const double* siga, const double* sigb, const unsigned N,
                    const unsigned interp, const double max_tau, const unsigned int fs)
{
    _gcc_setup(N);

    unsigned max_shift = 0;
    double max_val;
    unsigned max_idx;

    /* Compute the Generalized Cross-Correlation using the given weighting function */
    _gcc(siga, sigb, N, interp, max_tau, &max_shift);

    printf("\nmax_shift is : %d \n", max_shift);

    _max_index(shifted_xcorr, 2*max_shift, &max_val, &max_idx);

    printf("max_idx is : %d\n", max_idx);
    int shift = max_idx - max_shift;

    printf("Shift is : %d \n", shift);
    double tau = (double)shift / (double)(interp * fs);

    printf("tau is : %lf \n", tau);

    return  tau;

}