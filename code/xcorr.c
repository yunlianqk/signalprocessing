#include <assert.h>
#include <stdio.h>
#include <string.h>

#define M 5

typedef struct {
  float real;
  float imag;
} complex;

/*---------------------------------------------------------------------
  Routine CORRE: https://en.wikipedia.org/wiki/Cross-correlation
  input parameters:
     x  :m dimensioned complex array.
     y  :m dimensioned complex array.
     m  :the dimension of x and y.
     n  :point numbers of correlation.
  output parameters:
     r  :should be from [-(m-1), (m-1)], but we shift it to [0, 2m-1].
---------------------------------------------------------------------*/
void corre(complex x[], complex y[], complex r[], int m, int n) {
  assert(n == 2 * m - 1);
  for (int i = -(m - 1); i <= m - 1; ++i) {
    for (int j = 0; j < m; ++j) {
      int temp = i + j;
      if (temp >= 0 && temp <= m - 1) {
        r[i + m - 1].real +=
            x[j].real * y[j + i].real + x[j].imag * y[j + i].imag;
        r[i + m - 1].imag +=
            x[j].real * y[j + i].imag - x[j].imag * y[j + i].real;
      }
    }
  }
}

int main(void) {
  complex x[M];
  complex y[M];
  complex r[2 * M - 1];
  memset(x, 0, sizeof(x));
  memset(y, 0, sizeof(y));
  memset(r, 0, sizeof(r));

  x[0].real = 5;
  x[1].real = 1;
  x[2].real = 2;
  x[3].real = 3;
  x[4].real = 4;

  y[0].real = 1;
  y[1].real = 2;
  y[2].real = 4;
  y[3].real = 5;
  y[4].real = 6;

  corre(x, y, r, sizeof(x) / sizeof(complex), sizeof(r) / sizeof(complex));
  for (int i = 0; i < sizeof(r) / sizeof(complex); ++i) {
    printf("r[%d].real=%.2f, r[%d].imag=%.2f\n", i, r[i].real, i, r[i].imag);
  }
}