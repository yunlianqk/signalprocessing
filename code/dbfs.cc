// For digital signal dB is typically expressed relative to the full scale amplitude.
// 1.0 == 0dB
// 0.5 == -6dB
// 0.25 == -12dB
// ...
// 0.0  == -inf dB
// dBFS = 20log10(abs(sample value) / highest possible sample value)

#include <climits>
#include <iostream>
#include <math.h>
using std::cout;
using std::endl;
using std::cerr;

int main(int argc, char* argv[]) {
	if (argc != 2) {
		cerr << "Usage: dbfs sampleValue(in 16 bit depth)" << endl;
		return -1;
	}
	float sampleValue = atof(argv[1]);
	if(sampleValue == 0.0f) sampleValue = std::numeric_limits<float>::min();
	float db = 20 * log10(fabs(sampleValue) / SHRT_MAX);
	cout << "dbfs = " << db << endl;
	return 0;
}