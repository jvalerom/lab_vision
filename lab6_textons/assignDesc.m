function [ allDesc ] = assignDesc( fb, databasePath , textons, dataset, predict)
% function [ allDesc ] = assignDesc( fb, databasePath , textons, dataset, predict)
%
% Produces a texton histogram vector for each image in the dataset and adds
% it to the image descriptor dataset. In the final image descriptor dataset
% there is one texton histogram vector for each image in the provided image
% dataset.
%
% Input:
%   fb:             filter bank to be applied
%   databasePath:   training database pathname
%   textons:        the texton matrix to be used
%   dataset:        image dataset directory
%   predict:        boolean flag for including (true) or not including (false) a predictor column 
%
% Output:
%   allDesc:        nXm matrix with n image descriptors and each image
%   described by a histogram vector with m bins.
%
% José Valero <ja.valero@uniandes.edu.co>
% March 2016
%
    addpath('lib')
    %databasePath = '/home/jvalero/ArchivosWindows/Pasantia/Textons/data/textures/';% Where database is

    if predict
        allDesc = zeros(numel(dir(fullfile(databasePath, dataset, '*.jpg'))),size(textons,1) + 1);
    else
        allDesc = zeros(numel(dir(fullfile(databasePath, dataset, '*.jpg'))),size(textons,1));
    end
    
    if predict
        cellHead = cell(1,size(textons,1) + 1);
    else
        cellHead = cell(1,size(textons,1));
    end
    
    for i = 1:size(textons,1),
        cellHead(i) = {strcat('texton',num2str(i))};
    end
    
    if predict
        cellHead(size(textons,1) + 1) = {'textureCateg'};
    end
    
    vartextons = 0;
    textonsT = textons';
    
    for i = 1:25,% There are 25 texton categories,
        fwrite(1,sprintf('%d:Processing texture T%02d\n',i,i));
        datasetDir = dir(fullfile(databasePath, dataset, sprintf('T%02d_*.jpg',i)));

        for j = 1: numel(datasetDir),
            fwrite(1,sprintf('%d:assigning texton descriptors(%d.%d) \n%s\n',vartextons + j,i,j,datasetDir(j).name));
            imfb = fbRun(fb,double(imread(fullfile(databasePath, dataset,datasetDir(j).name)))/255);
            tmap = assignTextons(imfb,textonsT);
            desc = histc(tmap(:),1:200)/numel(tmap);
            allDesc(vartextons + j,1:size(textons,1)) = desc';
            
            if predict
                allDesc(vartextons + j,size(textons,1) + 1) = i;
            end
        end
        
        vartextons = vartextons + numel(datasetDir);
    end
    
    % following R2016a matlab line is not supported by R2014a fitcknn and
    % TreeBagger functions used in classifying
%     asignData = array2table(allDesc,'VariableNames',cellHead);
end
