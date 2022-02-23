# Hyperion image processing on MATLAB
This code is part of the MALMO project, a project running in collaboration between IRCM (Montpellier), LPHI laboratory (Montpellier) and ICM laboratory (Paris). 

The main purpose of this code is to provide a solution to get cells centroids from melanoma hyperion image and to compare extracted centroids with those obtain using the IMC segmentation pipeline from the Bodenmiller Lab.

## Data
All used data have to be available in the data folder. Data should available in different folders:

1. data_from_IMC_pipeline: containing outputs files from the IMC Segmentation pipeline
2. mcd_human_melanoma: containing all hyperion input image related to human melanoma
3. mcd_murin_ melanoma: containing all hyperion input image related to human melanoma

## Main files

Two main files are now available:
1. main_human_melanoma_13391.m: allows to execute processing on human melanoma hyperion images
2. main_21-IMC-M-05-LLC_d100-Takis murin melanoma.m: allows to execute processing on human melanoma hyperion images

Scripts have to be run on Matlab (used version: Matlab R2013b)

## Functions

This folder contains all matlab functions used in main files. 

### askUserExpValues

Ask the user the values of two parameters **l** and **k** that will be used for the image filtering (application of an exponential filter)

Values are assigned to l and k variables

### PreprocessImages
This function is used for pre processing the input images: application of an exponential operator and a gaussian filter.

Application of an exponential operator: We apply an exponential operator on input image to smooth the image in order to preserve important feature from the image while removing the noise.

Application of a gaussian filter: Next, a gaussian filter is applied on the image to improve the feature detection of the specific marker on the image. The gaussian filter is applied via the **fspecial** function of matlab

**l**: multiplicative factor in the exponential function (default = 1/100)
**k**: step value (default = 1)
**h**: size of the filter (default = [10 10])
**sigma**: standard deviation value (default = 2)

The result of all pre processing operation on each marker are registered in the **outputs/pre_processing** folder.


### GetCentroids

This function is used on the input filtered image to retrieve the cells centroids position.

First the function asks the user for **treshold value** that will be used for the location of the highest maxima intensity pixels regions in the image.

The **imextendmax** is then used on the image to locate pixels with a constant high intensity value. The output (**EXBW_Im**) is a logical matrix with the same size than the image with 1 value for high intensity pixels.

High intensity regions corresponds to nucleus regions on the input image, but we want only one point per region as we only want to locate the centroid of cells. We then use the **bwconncomp** matlab function to locate all connected component in the EXBW_Im matrix and reduce those regions to only one point that will be use as the cells centroids.

The position corresponding to high intensity values are then set to 0 in the initial filtered input image.

The resulting image is registered in the **outputs/centroids** folder.

![Centroids](./illustrations/centroids1.png "Comparison")
![Centroids zoom](./illustrations/centroids2.png "Comparison")

### saveLocations

Location of cells centroids are registered in a csv file in the **outputs/centroids** folder

### compareSegmentation
This function is used to display in a same picture a small region of the input images with locations of cell's centroids performed by the matlab processing code and by the Bodenmiller Lab's IMC Segmentation Pipeline. A Voronoi segmentation is applied from the cell's centroids performed by the code.

Input files: Input image processed by the IMC pipeline, X and Y coordinates from the IMC pipeline, input image processed by the matlab code, X and Y coordinates from the matlab code.

The main goal is to display the same region of images and overlay centroids position given by the two approaches as well as the cell segmentations.

![Comparison](./illustrations/comparison.png "Comparison")

## Outputs
The output folder is divided by the type of input image used:
1. mcd_human_melanoma
2. mcd_murin_melanoma

In each files, output are distributed in specific folders:
1. pre_processing: contains the before/after image of pre processing operations done on selected markers
2. centroids: contains an image positioning the cells centroids detected in input image and a csv file that report cells centroids locations
3. compare_segmentation: contains the image comparing the segmentation performed with the current code vs. the segmentation performed by the IMC segmentation pipeline

