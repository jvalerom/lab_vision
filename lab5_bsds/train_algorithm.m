function [] = train_algorithm( imgDir, method, featureSpace, clusterRange,outDir )
% function [] = train_algorithm( imgDir, method, featureSpace )
%
%   This function test segment_by_clustering function using data in imgDir and
%   method and featureSpace given.
    iids = dir(fullfile(imgDir,'*.jpg'));
    for i = 1:numel(iids),
        fwrite(2,sprintf('%d:Processing \n%s\n',i,iids(i).name));
        img = imread(fullfile(imgDir, iids(i).name));
        outFile = fullfile(outDir, strcat(iids(i).name(1:end-4), '.mat'));
        %segs = segment_by_clustering(img,clusterRange,'feature_space',featureSpace,'clustering_method',method);
        segs = segment_by_clusteringMarkers(img,clusterRange,'feature_space',featureSpace,'clustering_method',method);
        save(outFile,'segs');
        clear segs;
    end

end

