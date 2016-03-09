# Segmentation practice

## Data


The data was downloaded from the course server using http

- http://157.253.63.7/images.tar.gz

## Implement a segmentation method

I implemented my own segmentation method using what I had learned in class. It was a matlab function with the following signature

```matlab
function my_segmentation = segment_by_clustering( rgb_image, feature_space, clustering_method, number_of_clusters)
```
Where

- feature_space : 'rgb', 'lab', 'hsv', 'rgb+xy', 'lab+xy', 'hsv+xy'
- clustering_method = k-means, gmm, hierarchical or watershed.

The output of the function is an image where each pixel has a cluster label.

## Test your function

To test the output of my function I used the test_segment_by_clustering function (with the following signature) that I built in matlab which applies all supported methods and feature spaces to a given image and number of groups.

```matlab
function [] = test_segment_by_clustering(rgbImagePath,number_of_clusters)
```
Where

- rgbImagePath 		: rgb image Pathname
- number_of_clusters 	: number of clusters.


## Notes

- In order not to run into memory problems the original image was initially downsampled and at he end this was upsampled
- x and y channels was scaled with less weight to make them comparable in calculating the total gradient when using watershed method.

## End

Both segmentation and test functions was uploaded to the repository
