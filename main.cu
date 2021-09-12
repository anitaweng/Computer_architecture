#include <iostream>
#include <cuda_runtime.h>
#include <boost/program_options.hpp>
#include <opencv2/core/core.hpp>
#include <opencv2/highgui/highgui.hpp>
#include <opencv2/opencv.hpp>
#include <opencv2/imgproc/imgproc.hpp>
#include <vector>
#include <stdio.h>
#include "cuda.h"

using namespace cv;

using namespace std;
using namespace boost::program_options;

size_t numRows, numCols;

//extern uchar4* mirror_ops(uchar4 *d_inputImageRGBA, size_t numRows, size_t numCols, bool vertical);

void loadImageRGBA(string &filename, uchar4 **imagePtr,size_t *numRows, size_t *numCols)
{
    // loading the image
    Mat image = imread(filename.c_str(), CV_LOAD_IMAGE_COLOR);
    if(image.empty())
    {
      cerr<<"Failed to load image: "<<filename<<endl;
      exit(1);
    }
    if(image.channels() != 3)
    {
      cerr<<"Image must be color!"<<endl;
      exit(1);
    }
    if(!image.isContinuous())
    {
      cerr<<"Image isn't continuous!"<<endl;
      exit(1);
    }

    // forming a 4-channel(RGBA) image.
    Mat imageRGBA;
    cvtColor(image, imageRGBA, CV_BGR2RGBA);
    //cout<<imageRGBA<<endl<<endl;
    *imagePtr = new uchar4[image.rows * image.cols];
    unsigned char *cvPtr = imageRGBA.ptr<unsigned char>(0);
    for(size_t i = 0; i < image.rows * image.cols; ++i)
    {
      (*imagePtr)[i].x = cvPtr[4*i + 0];
      (*imagePtr)[i].y = cvPtr[4*i + 1];
      (*imagePtr)[i].z = cvPtr[4*i + 2];
      (*imagePtr)[i].w = cvPtr[4*i + 3];
    }
    *numRows = image.rows;
    *numCols = image.cols;
}

void saveImageRGBA(uchar4* image, string &output_filename,size_t numRows, size_t numCols)
{
    // Forming the Mat object from uchar4 array.
    int sizes[2] = {numRows, numCols};
    Mat imageRGBA(2, sizes, CV_8UC4, (void *)image);
    // Converting back to BGR system
    Mat imageOutputBGR;
    cvtColor(imageRGBA, imageOutputBGR, CV_RGBA2BGR);
    //cout<<imageOutputBGR<<endl<<endl;
    // Writing the image
    imwrite(output_filename.c_str(), imageOutputBGR);
}

uchar4* load_image_in_GPU(string filename)
{ 
    // Load the image into main memory
    uchar4 *h_image, *d_in;
    loadImageRGBA(filename, &h_image, &numRows, &numCols);
    // Allocate memory to the GPU
    cudaMalloc((void **) &d_in, numRows * numCols * sizeof(uchar4));
    cudaMemcpy(d_in, h_image, numRows * numCols * sizeof(uchar4), cudaMemcpyHostToDevice);
    // No need to keep this image in RAM now.
    free(h_image);
    return d_in;
}

int main(int argc, char* argv[])
{
    string input_file = "images.jpeg";
    string output_file = "output.jpg";
    string vh = argv[1];
    uchar4 *d_in = load_image_in_GPU(input_file);
    uchar4 *h_out = NULL;
    // Performing the required operation
    bool isVertical = ((vh == "v") ? true:false);
    h_out = mirror_ops(d_in, numRows, numCols, isVertical);
    cudaFree(d_in);
    if(h_out != NULL)
      saveImageRGBA(h_out, output_file, numRows, numCols);
    /*uchar4 *g_out = NULL;
    g_out = apply_filter(d_in, numRows, numCols, filter_name); 
    cudaFree(d_in);
    if(g_out != NULL)
      saveImageRGBA(g_out, gray, numRows, numCols);*/  
}
