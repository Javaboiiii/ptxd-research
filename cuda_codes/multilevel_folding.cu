__global__ void multilevel_folding(int *a, int *b, int *c, int n) {
    int i = blockIdx.x * blockDim.x + threadIdx.x;
    if (i < n) {
        int x = a[i] * 2 + 3;
        int y = b[i] - 5;
        int z = x + y; // Folded expression

        if (z > 10) {
            int w = z * 2 + x; // Uses previously folded expression z and x
            c[i] = w + a[i];   // Multiple levels of folding
        } else {
            int w = z - y + 4; // Uses previously folded expression z and y
            c[i] = w - b[i];
        }
    }
}

int main() { 
    return 0; 
}