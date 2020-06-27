#include <stdio.h>

__global__
void count_sort(int n, int* a, int* b, int* c) {
    int i = threadIdx.x;
    int iinc = blockDim.x;

    int j = 0;
    int jinc = gridDim.x;

    for(; i < n; i += iinc) {
        for(;j<n;j+=1) {
            if((a[i] > a[j]) || (a[i] == a[j] && i > j)) {
                c[i]++;
            }
        }
    }
}

int main(void) {
    int n = 2048;
    int *a, *b, *c;
    cudaMallocManaged(&a, n*sizeof(int));
    cudaMallocManaged(&b, n*sizeof(int));
    cudaMallocManaged(&c, n*sizeof(int));

    for(int i=0;i<n;i++) a[i] = (i+1);
    for(int i=0;i<n;i++) c[i] = 0;

    count_sort<<<1,256>>>(n,a,b,c);
    cudaDeviceSynchronize();

    bool flag = true;
    for(int i=0;i<n;i++) {
        printf("%d ",c[i]);
        if(c[i] != i) flag = false;
    }
    if(flag) printf("\nTrue \n");
    else printf("\nFalse \n");

    cudaFree(a);
    cudaFree(b);
    cudaFree(c);

    return 0;
}