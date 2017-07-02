#include <math.h>
#include <stdio.h>

#define LENGTH 5

float corre(float x[], float y[], int n)
{
    float x_mean = 0.0f;
    float y_mean = 0.0f;

    float sum = 0.0f;
    for(int i = 0; i < n; ++i) {
        sum += x[i];
    }
    x_mean = sum/n;

    sum = 0.0f;
    for(int i = 0; i < n; ++i) {
        sum += y[i];
    }
    y_mean = sum/n;
    
    float dot = 0.0f;
    for(int i=0; i < n; ++i) {
        dot += (x[i] - x_mean) * (y[i] - y_mean);
    }

    float x_vari = 0.0f;
    for(int i=0; i < n; i++) {
        x_vari += (x[i] - x_mean) * (x[i] - x_mean);   
    }
    x_vari = sqrt(x_vari);
    
    float y_vari = 0.0f;
    for(int i=0; i < n; i++) {
        y_vari += (y[i] - y_mean) * (y[i] - y_mean);   
    }
    y_vari = sqrt(y_vari);    
    return dot / (x_vari * y_vari);
}

int main() {
    float x[LENGTH] = {0.0f};
    float y[LENGTH] = {0.0f};
    x[0] = 1;
    x[1] = 2;
    x[2] = 2;
    x[3] = 3;
    x[4] = 4;

    y[0] = 1;
    y[1] = 1;
    y[2] = 2;
    y[3] = 3;
    y[4] = 4;
    float result = corre(x, y, sizeof(x) / sizeof(float));
    printf("the result is %f\n", result);
    return 1;
}
