#include <stdio.h>
#include <cuda.h>
#include "vector.h"

__global__ void sum(vector3 *x,int N){
    int tid =  blockDim.x * blockIdx.x + threadIdx.x;
    if(tid < N){
        x[1][tid] = tid;
    }
}
int main(){
    int N = 130;
    int nbytes = sizeof(vector3) * N;
    vector3 *hx, *dx;
    int i;


    cudaMalloc((void**)&dx, nbytes);
    hx = (vector3 *)malloc(nbytes);
    for(i = 0; i< N; i++){
        hx[1][i] = 1;
        printf("%g\n",hx[1][i]);
    }
    
    cudaMemcpy(dx, hx, nbytes, cudaMemcpyHostToDevice);
    dim3 dimGrid(3);
    dim3 dimBlock(64);
    sum<<<dimGrid,dimBlock>>>(dx,N);
    //cudaDeviceSynchronize();
    cudaMemcpy(hx, dx, nbytes, cudaMemcpyDeviceToHost);
    for(i = 0; i< N; i++){
        printf("%g\n",hx[1][i]);
    }
    cudaFree(dx);
    free(hx);
    return 0;
}
