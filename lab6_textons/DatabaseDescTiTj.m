function [ textons ] = DatabaseDescTiTj( fb, databasePath , tIni, tEnd)
% function [ textons ] = DatabaseDesc( databasePath )
%
% Produces texton descriptor for a training dataset based on pixels sampled from
% each filtered image in order to avoid a lack of memory condition.
%
% Input:
%   fb:             filter bank to be applied
%   databasePath:	training database pathname
%   tIni:           texture category code from wich to produce the textons
%   tEnd:           texture category code until wich to produce the textons
%
% Output:
%   textonDescs:    cell of texton descriptors
%
% José Valero <ja.valero@uniandes.edu.co>
% March 2016
%
    addpath('lib')
    %databasePath = '/home/jvalero/ArchivosWindows/Pasantia/Textons/data/textures/';% Where database is

    % Training images for textons creation
%     textonDescs = cell(25,numel(fb));
% 
%     for i = 1:25,% There are 25 texton categories, each one of them produces a texton descriptor
%         trainDir = dir(fullfile(databasePath, 'train', sprintf('T%02d_*.jpg',i)));
%         images = cell(1,numel(trainDir));
% 
%         for j = 1: numel(trainDir),
%             images(1,j) = double(rgb2gray(imread(fullfile(databasePath,'train',trainDir(j).name))))/255;
%         end
% 
%         % this image set represents only one texton
%         k = 1;
% 
%         % diccionario de textones
%         [~,textons] = computeTextons(fbRun(fb,images),k);
%         textonDescs(i,:) = textons(1,:);
%     end
    %images = cell(size(fb));
%     textons = [];
    fbvec = cell(size(fb));

    for j = 1:numel(fb),
        fbvec{j} = zeros(30 * (tEnd - tIni + 1),40 * 30);
    end
        

    for i = tIni:tEnd,% There are 25 texton categories
        fwrite(1,sprintf('%d:Processing texture T%02d\n',i,i));
        trainDir = dir(fullfile(databasePath, 'train', sprintf('T%02d_*.jpg',i)));
        numImages = numel(trainDir);
        %textonst = zeros(nTexton4Cat,numel(fb));

        for j = 1:numImages,
            fwrite(1,sprintf('%d.%d: Filter Bank processing \n%s\n',i,j,trainDir(j).name));
            imf = fbRun(fb,double(imread(fullfile(databasePath, 'train',trainDir(j).name)))/255);
%             [~,textonsi] = computeTextons(imf,nTexton4Cat);
%             textonst = (textonst * (j - 1) + textonsi) / j;

            for k = 1:numel(fb),
                fbvec{k}((i -tIni) * 30 + 1:(i - tIni + 1) * 30,(j -1) * 40 + 1:j * 40) = imf{k}(1:16:end,1:16:end);
            end
            
        end
        
%         [~,textonst] = computeTextons(fbvec,nTexton4Cat);
        %textonst = (textonst * (j - 1) + textonsi) / j;

        % diccionario de textones
%         textons = [textons ; textonst];
%         for k = 1:numel(fb),
%             images{k} = [images{k};ims{k}];
%         end
        
    end
    
    save(sprintf('fbvec_%02d_%02d',tIni, tEnd),'fbvec');
    fwrite(1,sprintf('%d.%d: Filter Bank processing \n%s\n',i,j,trainDir(j).name));
    [~,textons] = computeTextons(fbvec,200);
    save(sprintf('textons_%02d_%02d',tIni, tEnd),'textons');
end
