#include <cstdio>

__global__ void loop_kernel(float *out, int n){
    int i = blockIdx.x*blockDim.x + threadIdx.x;
    int case_no = 1; 
    int k = 0; 
    switch(case_no){
        case 0: 
            k = 0.1f * 0.2; 
            break; 
        case 1: 
            k = 0.01f * 0.9f; 
            break; 
        default: 
            k = 0; 
    }
    out[i] = k; 
}

int main(){
    const int N = 8;
    float out[N];
    for(int i=0;i<N;i++) out[i]=0.0f;

    float *dout;
    cudaMalloc(&dout, N*sizeof(float));

    loop_kernel<<<1,N>>>(dout, N);
    cudaMemcpy(out, dout, N*sizeof(float), cudaMemcpyDeviceToHost);

    for(int i=0;i<N;i++) printf("%d: %f\n", i, out[i]);

    cudaFree(dout);
    return 0;
}
