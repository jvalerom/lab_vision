function [] = test_segment_by_clustering(rgbImagePath,clusterRange)
% function [] = test_segment_by_clustering(imagePath,number_of_clusters)
% This function tests, for an image pathname and a number of cluster, all supported features spaces and clustering methods. Input parameters are not validated.
%
% Input
%    rgbImagePath       : an image pathname of a rgb color space image.
%    clusterRange(i)    : range of cluster's number to be built.
%
% Output
%    segmentedImage     : a labeled image.
%
% José Valero
% 2016/03/02
%
feature_spaces = {'rgb', 'lab', 'hsv', 'rgb+xy', 'lab+xy', 'hsv+xy'};
clustering_methods = {'watershed'};%{'k-means','gmm', 'hierarchical', 'watershed'};
img = imread(rgbImagePath);

for i = 1:size(feature_spaces,2),
    for j = 1:size(clustering_methods,2),
        imsegs = segment_by_clustering(img,clusterRange,'feature_space',feature_spaces{i},'clustering_method',clustering_methods{j});

        for k = 1:size(clusterRange,2),
            figure('Name',strcat(clustering_methods{j},' segmentation using ', feature_spaces{i},' feature space'),'NumberTitle','off','MenuBar','none','ToolBar','none')
            imagesc(imsegs{k})
        end
    end
end
