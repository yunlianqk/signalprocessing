
// Generate random numbers follow Gaussian Distribution

#include <iostream>
#include <vector>
#include <math.h>
using std::cout;
using std::endl;
using std::vector;

const int32_t kNumRandGauss = 1000;
float RandUniform() {  // random between 0 and 1.
  return static_cast<float>((rand() + 1.0) / (RAND_MAX+2.0));
}

float RandGauss() {
  return static_cast<float>(sqrt(-2 * log(RandUniform()))
                            * cos(2*M_PI*RandUniform()));
}

int main() {
  double sum = 0.0f;
  vector<float> rand_gauss_;
  rand_gauss_.resize(kNumRandGauss);
  cout << "START,";
  for (int i = 0; i < kNumRandGauss; ++i) {
    rand_gauss_[i] = RandGauss();
    sum += rand_gauss_[i];
    cout << rand_gauss_[i] << ",";
  }
  cout << "END" << endl;
  cout << "sum: " << sum << " expection: " << sum / kNumRandGauss << endl;
  return 1;
}

