function [ imageSegs ] = segment_by_clustering( rgb_image, clusterRange,varargin)
% function [my_segmentation] = segment_by_clustering( rgb_image, feature_space, clustering method, number of clusters)
%
% Input
%    rgb_image          : an image in a rgb color space.
%    clusterRange       : range of segmentation's number as a row vector.
%    feature_space      : the feature space in which the cluster is to be
%                         done ('rgb', 'lab', 'hsv', 'rgb+xy', 'lab+xy',
%                         'hsv+xy'). Default: lba.
%    clustering_method  : the method of lustering to be applied (k-means,
%                         gmm, hierarchical, watershed). Default: k-means.
%
% Output
%    imageSegs          : a labeled images.
%
% Jos� Valero
% 2016/03/11
%
% Defaults values
feature_space = 'lab';
clustering_method = 'k-means';
imageSegs = cell(1,size(clusterRange,2));
% Inputs validation
    for i = 1:2:numel(varargin),
        par = varargin{i};
        
        if ~ischar(par), error('parameter name is not a string'); end
        
        if i==numel(varargin), error('parameter ''%s'' does not have a defined value',par); end
        
        value = varargin{i+1};
        
        switch par,
            case 'feature_space',
                switch value,
                    case {'rgb','lab','hsv', 'rgb+xy', 'lab+xy', 'hsv+xy'}, feature_space = value;
                    otherwise, error('invalid option feature_space=''%s''',val);
                end
            case 'clustering_method',
                switch value,
                    case {'k-means','gmm','hierarchical', 'watershed'}, clustering_method = value;
                    otherwise, error('invalid option clustering_method=''%s''',value);
                end
            %case 'number_of_clusters', number_of_clusters = value;
            otherwise, error('invalid parameter ''%s''',par);
        end
    end
    % max chanel value for scaling xy
    maxCh = max(max(max(rgb_image)));
    maxX = size(rgb_image,2);
    maxY = size(rgb_image,1);
    [xs, ys] = meshgrid([1:maxX],[1:maxY]);
    maxXY = max(maxX,maxY);
    xs = int16(ceil(double(xs) * (double(maxCh) / double(maxXY))) * 0.5);
    ys = int16(ceil(double(ys) * (double(maxCh) / double(maxXY))) * 0.5);
    % rgb_image to wanted feature_space convertion
    switch feature_space,
        case 'rgb',
            fsImage = rgb_image;
        case 'lab',
            cform = makecform('srgb2lab');
            fsImage = applycform(rgb_image,cform);
            %fsImage = double(fsImage(:,:,2:3));% The firs channel L is not used.
        case 'hsv',
            fsImage = rgb2hsv(rgb_image);
        case 'rgb+xy',
            fsImage = zeros(size(rgb_image,1),size(rgb_image,2),size(rgb_image,3) + 2);
            fsImage(:,:,[1:size(rgb_image,3)]) = rgb_image;
            fsImage(:,:,size(rgb_image,3) + 1) = xs;
            fsImage(:,:,size(rgb_image,3) + 2) = ys;
        case 'lab+xy',
            cform = makecform('srgb2lab');
            labImage = applycform(rgb_image,cform);
            fsImage = zeros(size(labImage,1),size(labImage,2),size(labImage,3) + 2);
            fsImage(:,:,[1:size(labImage,3)]) = labImage;
            fsImage(:,:,size(labImage,3) + 1) = xs;
            fsImage(:,:,size(labImage,3) + 2) = ys;
        case 'hsv+xy',
            hsvImage = rgb2hsv(rgb_image);
            fsImage = zeros(size(hsvImage,1),size(hsvImage,2),size(hsvImage,3) + 2);
            fsImage(:,:,[1:size(hsvImage,3)]) = hsvImage;
            fsImage(:,:,size(hsvImage,3) + 1) = xs;
            fsImage(:,:,size(hsvImage,3) + 2) = ys;
    end
    % clustering by using the wanted clustering_method
    initRows = size(fsImage,1);
    initCols = size(fsImage,2);
    downSampImage = imresize(fsImage, 0.5, 'bilinear');
    rows = size(downSampImage,1);
    cols = size(downSampImage,2);
    fsImageR = double(reshape(downSampImage,rows * cols,size(downSampImage,3)));
    
    switch clustering_method,
        case {'k-means','gmm'},
            
            for i = 1:size(clusterRange,2),
                
                switch clustering_method,
                    case 'k-means',
                        cluster_idx = kmeans(fsImageR,clusterRange(i),'distance','sqEuclidean', 'Replicates',3);
                    case 'gmm',
                        gmModel = fitgmdist(fsImageR,clusterRange(i),'Regularize',1e-5);   % First, adjusting GMM to data regularizing the covariance matrices
                        cluster_idx = cluster(gmModel,fsImageR);            % Then, applying the model
                end
                
                imageSegs{i} = imresize(reshape(cluster_idx,rows,cols), [initRows initCols], 'nearest');
            end
                
        case {'hierarchical','watershed'},
            
            switch clustering_method,
                case 'hierarchical',
                    % Ward distance takes into account the number of member in a cluster.This is used here
                    % in an attempt to avoid highly unbalanced (clusters with really few members) hierachy
                    dataLinkage = linkage(fsImageR,'ward','euclidean','savememory','on');

                    for i = 1:size(clusterRange,2),
                        cluster_idx = cluster(dataLinkage,'maxclust',clusterRange(i));
                        imageSegs{i} = imresize(reshape(cluster_idx,rows,cols), [initRows initCols], 'nearest');
                    end

               case 'watershed',
                    imageSegs = cell(1,10);
                    % Creted by using the procedure at http://www.mathworks.com/help/images/examples/marker-controlled-watershed-segmentation.html?prodcode=IP&language=en
                    hy = fspecial('sobel');
                    hx = hy';
                    nchanels = size(downSampImage,3);
                    %totalGradient = zeros(rows,cols);
                    singleChannel = double(zeros(rows,cols));

                    % Now, the total gradient is calculated as averaged sum of the
                    % gradient for each channel
        %             for i = 1:nchanels,
        %                 channel = double(downSampImage(:,:,i));
        %                 Iy = imfilter(channel, hy, 'replicate') / nchanels;
        %                 Ix = imfilter(channel, hx, 'replicate') / nchanels;
        %                 totalGradient = totalGradient + sqrt(Ix.^2 + Iy.^2);
        %             end

                    for i = 1:nchanels,
                        singleChannel = singleChannel + double(downSampImage(:,:,i)) / double(nchanels);
                    end

                    Iy = imfilter(double(singleChannel), hy, 'replicate');
                    Ix = imfilter(double(singleChannel), hx, 'replicate');
                    totalGradient = sqrt(Ix.^2 + Iy.^2);
                    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                    ucm = zeros(size(totalGradient));
                    
                    for h = 10:10:100,
                        marker = imextendedmin(totalGradient, h);
                        new_grad = imimposemin(totalGradient, marker);
                        basins = watershed(new_grad);
                        ucm = max(ucm,h * (basins == 0));
                        basinsMedian = ordfilt2(basins,9,ones(3,3)); 
                        basins(find(basins == 0)) = basinsMedian(find(basins == 0));% Because not clasified pixels are asigned 0 label 
                        imageSegs{h / 10} = imresize(reshape(basins,rows,cols), [initRows initCols], 'nearest');
                    end

                    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                     basins = watershed(totalGradient);
%                     basinsMedian = ordfilt2(basins,9,ones(3,3)); 
%                     basins(find(basins == 0)) = basinsMedian(find(basins == 0));% Because not clasified pixels are asigned 0 label 
%                     bsinIndx = unique(basins);
%                     basinMeans = zeros(size(bsinIndx,1),nchanels + 1);
%                     basinMeans(:,1) = bsinIndx;
%                     cellHead = cell(1,nchanels + 1);
%                     cellHead(1) = {'labels'};
% 
%                     for i = 1 : nchanels,
%                         aux = downSampImage(:,:,i);
%                         basinsMean = accumarray( basins(:), aux(:), [], @mean );
%                         basinMeans(:,i + 1) = basinsMean(bsinIndx);
%                         cellHead(i + 1) = {strcat('ch',num2str(i))};
%                     end
% 
%                     basinMeansCell = dataset2cell(join(dataset({basins(:),'labels'}),mat2dataset(basinMeans,'VarNames',cellHead)));
%                     fsImageR = cell2mat(basinMeansCell(2:end,2:end));
%                     clear basinMeansCell basinMeans basins;
%                     %cluster_idx = kmeans(fsImageR,number_of_clusters,'distance','sqEuclidean', 'Replicates',3);
%                     %fsImageR = double(reshape(downSampImage,initRows * initCols,size(downSampImage,3)));
%                     dataLinkage = linkage(fsImageR,'ward','euclidean','savememory','on');
            end
    end
                
end

