#include <stdio.h>
#include <cuda.h>
#include "vector.h"

__global__ void sum(vector3 *dx,int N){
    int tid =  blockDim.x * blockIdx.x + threadIdx.x;
    if(tid < N){
        dx[1][tid] = tid;
        //printf("%g\n",x[1][tid]);
    }
}
int main(){
    int N = 64;
    int nbytes = sizeof(vector3) * N;
    vector3 *hx, *dx;
    int i;

    cudaMallocManaged((void**)&dx, nbytes);
    //cudaMalloc((void**)&dx, nbytes);
    hx = (vector3 *)malloc(nbytes);
    for(i = 0; i< N; i++){
        dx[1][i] = 1;
        printf("%g\n",dx[1][i]);
    }
    //cudaMemcpy(dx, hx, nbytes, cudaMemcpyHostToDevice);
    dim3 dimGrid(1);
    dim3 dimBlock(64);
    sum<<<dimGrid,dimBlock>>>(dx,N);
    printf("CCCCCCCCCCCCCCCCCCC\n");
    cudaDeviceSynchronize();
    //cudaMemcpy(hx, dx, nbytes, cudaMemcpyDeviceToHost);
    for(i = 0; i< N; i++){
        printf("%g\n",dx[1][i]);
    }
    cudaFree(dx);
    free(hx);
    return 0;
}
