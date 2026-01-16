#include <cstdio>


__device__ __noinline__ int sqr(int n){
    return n * n; 
}

__global__ void vec_ops(const float *a, const float *b, float *c, int n){
    int i = blockIdx.x*blockDim.x + threadIdx.x;
    if(i < n){
        int k = 0; 
        while(k < 100){
            c[i] = sqr(a[i]) * b[i]; 
            k ++; 
        }
    }
}

int main(){
    const int N = 8;
    float a[N], b[N], c[N];
    for(int i=0;i<N;i++){ a[i]=i; b[i]=i*0.5f; c[i]=0.0f; }

    float *da, *db, *dc;
    cudaMalloc(&da, N*sizeof(float));
    cudaMalloc(&db, N*sizeof(float));
    cudaMalloc(&dc, N*sizeof(float));

    cudaMemcpy(da, a, N*sizeof(float), cudaMemcpyHostToDevice);
    cudaMemcpy(db, b, N*sizeof(float), cudaMemcpyHostToDevice);

    vec_ops<<<1, N>>>(da, db, dc, N);



    cudaMemcpy(c, dc, N*sizeof(float), cudaMemcpyDeviceToHost);

    for(int i=0;i<N;i++) printf("%d: %f\n", i, c[i]);

    cudaFree(da); cudaFree(db); cudaFree(dc);
    return 0;
}
