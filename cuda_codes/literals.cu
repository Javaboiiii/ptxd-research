#include <cstdio>

__global__ void vec_ops(const float *a, const float *b, float *c_out, int n,
                        char *out_ch, unsigned int *out_ui, 
                        long long unsigned int *out_llui,
                        bool *out_bt, bool *out_bf, int *out_ii, 
                        float *out_f, double *out_d){
    int i = blockIdx.x*blockDim.x + threadIdx.x;

    if (i < n) {
        c_out[i] = a[i] + b[i];
    }

    if (i == 0) {
        const char* s = "abcd";
        out_ch[0] = s[0];
        out_ch[1] = 'a'; 
        *out_ui = 10000;
        *out_llui = 1000000; 
        *out_bt = true; 
        *out_bf = false; 
        *out_ii = 20; 
        *out_f = 2.0f; 
        *out_d = 123.0; 
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

    char *d_ch; cudaMalloc(&d_ch, 2*sizeof(char));
    unsigned int *d_ui; cudaMalloc(&d_ui, sizeof(unsigned int));
    long long unsigned int *d_llui; cudaMalloc(&d_llui, sizeof(long long unsigned int));
    bool *d_bt; cudaMalloc(&d_bt, sizeof(bool));
    bool *d_bf; cudaMalloc(&d_bf, sizeof(bool));
    int *d_ii; cudaMalloc(&d_ii, sizeof(int));
    float *d_f; cudaMalloc(&d_f, sizeof(float));
    double *d_d; cudaMalloc(&d_d, sizeof(double));

    cudaMemcpy(da, a, N*sizeof(float), cudaMemcpyHostToDevice);
    cudaMemcpy(db, b, N*sizeof(float), cudaMemcpyHostToDevice);

    vec_ops<<<1, N>>>(da, db, dc, N, d_ch, d_ui, d_llui, d_bt, d_bf, d_ii, d_f, d_d);

    cudaMemcpy(c, dc, N*sizeof(float), cudaMemcpyDeviceToHost);

    for(int i=0;i<N;i++) printf("%d: %f\n", i, c[i]);

    cudaFree(da); cudaFree(db); cudaFree(dc);
    cudaFree(d_ch); cudaFree(d_ui); cudaFree(d_llui);
    cudaFree(d_bt); cudaFree(d_bf); cudaFree(d_ii);
    cudaFree(d_f); cudaFree(d_d);
    return 0;
}