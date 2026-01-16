#include <cstdio>

__device__ __noinline__ int sqr(int n){
    if(n <= 0) return 0; 

    return (n - 1) * (n - 2); 
}


__global__ void vec_ops(const float *a, const float *b, float *c, int n){
    int i = blockIdx.x*blockDim.x + threadIdx.x;
    // if(i < n) c[i] = a[i]*2.0f + b[i]*3.0f;

    
    int j = b[i] + sqr(a[i]);
    int k = a[i] * sqr(b[i]);
    int h = sqr(c[i]) + k + j; 
    c[i] = (float)h; 
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
