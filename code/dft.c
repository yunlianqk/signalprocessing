#include <math.h>
#include <stdio.h>

#define PI 3.1415926f
#define LEN 16

void dft(float * output_re, float * output_im, float * input, int N) {
	for(int k = 0; k < N; k++) {
		for(int n = 0; n < N; n++) {
			output_re[k] += input[n]*cos(k * 2 * PI * n / N);
			output_im[k] += -input[n]*sin(k * 2 * PI * n / N);
		}
	}
}

int main () {
	float input[LEN] =
	{0.672957,-0.453061,-0.835088,0.980334,0.972232,0.640295,0.791619,-0.042803,
	0.282745,0.153629,0.939992,0.588169,0.189058,0.461301,-0.667901,-0.314791};
	float output_re[LEN] = {0};
	float output_im[LEN] = {0};
	dft(output_re, output_im, input, LEN);
	printf("DFT\n");
	for(int i=0; i<LEN; i++) {
		printf("%f + i%f\n", output_re[i], output_im[i]);
	}
	printf("POWER\n");
	for(int i=0; i<LEN; i++) {
		printf("%f\n", output_re[i]*output_re[i] + output_im[i]*output_im[i]);
	}
}