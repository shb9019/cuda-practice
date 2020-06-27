#include <stdio.h>

__global__
void bin_search(int* a, int* l, int* r, int* e, int* searchValue) {
	int lm = l[0];
	int rm = r[0];
	int mm = ((lm+rm)/2);
	if(a[mm] >= searchValue[0]) rm = mm;
	else lm = mm+1;
	l[0] = lm;
	r[0] = rm;
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
	clock_t t; 
	t = clock();
	while(l[0] < r[0]) {
		bin_search<<<1,1>>>(a,l,r,e,searchValue);
		cudaDeviceSynchronize();
	}
	t = clock() - t; 
	printf("%d",(int)t);
	cudaFree(a);
	cudaFree(l);
	cudaFree(r);
	cudaFree(e);
	cudaFree(searchValue);
	return 0;
}