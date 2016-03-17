function subsegs(segDir, subsegDir, numSegs)
% subsegs(inDir, outDir)
%
% Get a segmentation images subset.
%
% INPUT
%   imgDir: folder containing original images
%   inDir:  segmentation results pathname with collections of segmentations stored in a mat file
%   outDir: folder where evaluation results will be stored
%
% José Valero
%<ja.valero@uniandes.edu.co>

segsIm = dir(fullfile(segDir,'*.mat'));
for i = 1:numel(segsIm),
    segimg = fullfile(segDir, segsIm(i).name);
    load(segimg);
    segs = segs(1,1:numSegs);
    subsegimg = fullfile(subsegDir, segsIm(i).name);
    save(subsegimg,'segs');
end
