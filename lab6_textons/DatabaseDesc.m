function [ allTextons ] = DatabaseDesc( fbSize )
% function [ textons ] = DatabaseDesc( databasePath )
% Input:
%   databasePath:	training database pathname
%
% Output:
%   textonDescs:    cell of texton descriptors
%
%
    addpath('lib')
    %databasePath = '/home/jvalero/ArchivosWindows/Pasantia/Textons/data/textures/';% Where database is

    allTextons = zeros(100,fbSize);

    for i = 1:25,% There are 25 texton categories, each one of them produces four texton descriptor
        clear textons;
        fwrite(1,sprintf('%d:loading texton descriptors fo texture T%02d\n',i,i));
        load(sprintf('textons_%02d_%02d',i, i));
        allTextons((i - 1) * 4 +  1:i * 4,:) = textons;
    end
    
    save('allTextons','allTextons');
end

