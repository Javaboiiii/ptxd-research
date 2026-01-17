#include <cstdio>

__global__ void branch_kernel(float *out, int n){
    int i = blockIdx.x*blockDim.x + threadIdx.x;
    if(i < n && i > 0){
        if ((i & 1) == 0) out[i] = 1.0f;
        else out[i] = -1.0f;
    }

    if(i < n || i > 0){
        if ((i & 1) == 0) out[i] = 1.0f;
        else out[i] = -1.0f;
    }
}

int main(){
    const int N = 8;
    float out[N];
    for(int i=0;i<N;i++) out[i]=0.0f;

    float *dout;
    cudaMalloc(&dout, N*sizeof(float));

    branch_kernel<<<1,N>>>(dout, N);
    cudaMemcpy(out, dout, N*sizeof(float), cudaMemcpyDeviceToHost);

    for(int i=0;i<N;i++) printf("%d: %f\n", i, out[i]);

    cudaFree(dout);
    return 0;
}
