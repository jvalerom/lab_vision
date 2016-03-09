function [] = test_segment_by_clustering(rgbImagePath,number_of_clusters)
% function [] = test_segment_by_clustering(imagePath,number_of_clusters)
% This function tests, for an image pathname and a number of cluster, all supported features spaces and clustering methods. Input parameters are not validated.
%
% Input
%    rgbImagePath       : an image pathname of a rgb color space image.
%    number_of_clusters : the number of clusters to be built.
%
% Output
%    segmentedImage     : a labeled image.
%
% José Valero
% 2016/03/02
%
feature_spaces = {'rgb', 'lab', 'hsv', 'rgb+xy', 'lab+xy', 'hsv+xy'};
clustering_methods = {'k-means','gmm', 'hierarchical', 'watershed'};
img = imread(rgbImagePath);

for i = 1:size(feature_spaces,2),
    for j = 1:size(clustering_methods,2),
        segim = segment_by_clustering(img,'feature_space',feature_spaces{i},'clustering_method',clustering_methods{j},'number_of_clusters',number_of_clusters);
        %image(segm)
	%colormap colorcube
        figure('Name',strcat(clustering_methods{j},' segmentation using ', feature_spaces{i},' feature space'),'NumberTitle','off','MenuBar','none','ToolBar','none')
        imagesc(segim)
    end
end
