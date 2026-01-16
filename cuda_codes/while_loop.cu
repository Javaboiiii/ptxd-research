#include <cstdio>

__global__ void loop_kernel(float *out, int n){
    int i = blockIdx.x*blockDim.x + threadIdx.x;
    if(i < n){
        float s = 0.0f;
        int k = 0;
        while(k < 100){
            s += (i + 1.0f) * 0.001f * k;
            k ++; 
        }
        out[i] = s;
    }
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
