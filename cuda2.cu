#include <cuda_runtime.h>
#include <stdio.h> 
#include <iostream>
using namespace std;

/* Mirror operations */
__global__ 
void mirror(uchar4* inputChannel, uchar4* outputChannel, int numRows, int numCols, bool vertical)
{
	int col = blockIdx.x * blockDim.x + threadIdx.x;
	int stripe = blockDim.x * gridDim.x;
	for(int i=col; i<numRows*numCols; i=i+stripe)
	{
		 unsigned char Y = 0.299 * inputChannel[i].x + 0.587 * inputChannel[i].y + 0.114 * inputChannel[i].z;
		 if(vertical)
		 	outputChannel[i/numCols*numCols+(numCols-i%numCols)-1] = make_uchar4(Y, Y, Y, 255);
		 else
			outputChannel[(numRows- (i/numCols) -1)*numCols +(i%numCols)] = make_uchar4(Y, Y, Y, 255);
	}
}


uchar4* mirror_ops(uchar4 *d_inputImageRGBA, size_t numRows, size_t numCols, bool vertical)
{
  //Creat Timing Event
  cudaEvent_t start, stop;
  cudaEventCreate (&start);
  cudaEventCreate (&stop); 

  //Set reasonable block size (i.e., number of threads per block)
  dim3 blockSize(9);
  //Calculate Grid SIze
  dim3 gridSize(6);
  
  //Calculate number of pixels
  size_t numPixels = numRows * numCols;

  //Allocate Memory Space on Device for output image
  uchar4 *d_outputImageRGBA;
  cudaMalloc(&d_outputImageRGBA, sizeof(uchar4) * numPixels);
  
  //start Timer
  cudaEventRecord(start, 0);

  //Call mirror kernel.
  mirror<<<gridSize, blockSize>>>(d_inputImageRGBA, d_outputImageRGBA, numRows, numCols, vertical);

  //Stop Timer
  cudaEventRecord(stop, 0);
  cudaEventSynchronize(stop); 
  cudaDeviceSynchronize(); 
 
  //Initialize memory on host for output uchar4*
  uchar4* h_out;
  h_out = (uchar4*)malloc(sizeof(uchar4) * numPixels);

  //Copy output from device to host
  cudaMemcpy(h_out, d_outputImageRGBA, sizeof(uchar4) * numPixels, cudaMemcpyDeviceToHost);
  
  //Cleanup memory on device
  cudaFree(d_inputImageRGBA);
  cudaFree(d_outputImageRGBA);
  
  //Calculate Elapsed Time
  float elapsedTime; 
  cudaEventElapsedTime(&elapsedTime, start, stop);
  printf("GPU time = %5.2f ms\n", elapsedTime);

  //return h_out
  return h_out;
}
