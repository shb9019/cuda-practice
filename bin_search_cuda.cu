#include <stdio.h>
#include <time.h>

__global__
void bin_search(int* a, int* l, int* r, int* e, int* searchValue) {
	int idx = threadIdx.x;
	int lm = l[0];
	int rm = r[0];
	int gap = (int)ceil((float)(rm-lm+1)/(float)(256));
	int num_proc = (int)ceil((float)(rm - lm + 1)/(float)gap);
	int currl = idx*gap + lm;
	if(currl > rm) return;
	int currr = min((idx+1)*gap + lm,rm+1) - 1;
	if(searchValue[0] >= a[currl] && searchValue[0] <= a[currr]) {
		l[0] = currl;
		r[0] = currr;
	}
}

int main(int argc, char* argv[]) {
	int n;
	scanf("%d",&n);
	int *a;
	int *searchValue;
	cudaMallocManaged(&a, n*sizeof(int));
	cudaMallocManaged(&searchValue, sizeof(int));
	scanf("%d",&searchValue[0]);
	for(int i=0;i<n;i++) scanf("%d",&a[i]);
	int *l, *r;
	int *e;
	cudaMallocManaged(&l, sizeof(int));
	cudaMallocManaged(&r, sizeof(int));
	cudaMallocManaged(&e, sizeof(int));
	l[0] = 0; r[0] = (n-1);
	while(l[0] < r[0]) {
		bin_search<<<1,256>>>(a,l,r,e,searchValue);
		cudaDeviceSynchronize();
	}
	printf("%d\n",l[0]);
	cudaFree(a);
	cudaFree(l);
	cudaFree(r);
	cudaFree(e);
	cudaFree(searchValue);
	return 0;
}