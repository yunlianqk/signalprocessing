#include <cstdlib>
#include <ctime>
#include <iostream>

const static int kSize = 500;
const static float kK = 0.5f;

int main(int argc, char *argv[]) {
  float x[kSize] = {0};
  float y[kSize] = {0};
  srand((unsigned)time(0));
  for (int n = 0; n < kSize; ++n) {
    x[n] = (rand() % 100) + 1;
  }
  y[0] = (1 - kK) * x[0];
  for (int n = 1; n < kSize; ++n) {
    y[n] = y[n - 1] * kK + (1 - kK) * x[n];
  }

  for (int n = 0; n < kSize; ++n) {
    std::cout << x[n] << " ";
  }
  std::cout << std::endl;

  for (int n = 0; n < kSize; ++n) {
    std::cout << y[n] << " ";
  }
  std::cout << std::endl;
}