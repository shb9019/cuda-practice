#include <stdio.h>

__global__ void helloFromGPU(void) {
    printf("Hello World from GPU %d!\n",threadIdx.x);
}

int main(void) {
    printf("Hello World from CPU\n");
    helloFromGPU <<<1, 100>>>();
    cudaDeviceSynchronize();
    return 0;
}