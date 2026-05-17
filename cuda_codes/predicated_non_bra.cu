__global__ void predicated_non_bra(int *a, int *b, int *c, int n) {
    int i = blockIdx.x * blockDim.x + threadIdx.x;
    if (i < n) {
        int valA = a[i];
        int valB = b[i];
        int res;
        
        asm("{\n\t"
            ".reg .pred %%p;\n\t"
            "setp.gt.s32 %%p, %1, %2;\n\t"
            "mov.u32 %0, 0;\n\t"     
            "@%%p add.s32 %0, %1, %2;\n\t" 
            "}" : "=r"(res) : "r"(valA), "r"(valB));
            
        c[i] = res;
    }
}

int main() { 
    return 0; 
}