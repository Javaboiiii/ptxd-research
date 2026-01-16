#include <cstdio> 

__device__ __noinline__ int sqr(int n){
    return n * n; 
}

__global__ void vec_ops(const float* a, const float* b, float* c, int n){
    int i = blockDim.x * blockIdx.x + threadIdx.x;  


    for(int j = 0; j <= 100; j ++){
        int case_no = i % 2; 

        switch(case_no){
            case 0: 
                for(int k = j; k <= 100; k ++) c[i] = a[i] * b[i] * 0.2f; 
                break; 
            case 1: 
                c[i] = b[i] * 0.2f; 
                break; 
            default: 
                c[i] = a[i] * b[i]; 
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
