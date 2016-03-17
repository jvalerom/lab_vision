function [] = bench_bsds500(imgDir,gtDir,inDir,outDir)
%function [] = bench_bsds500(imgDir,gtDir,inDir,outDir)
%
% Applies the BSBS500 benchmark methodogy to an segmented image set.
%
% Inputs
%   imgDir  : directory path of test image set on which evaluation is to be made
%   gtDir   : directory path of ground truth image set against the evaluation is to be made
%   inDir   : directory path of segmented image set to be evaluated
%   imgDir  : directory path where evaluation outcomes will be set
%
addpath benchmarks % there are the base evaluation algorithms

mkdir(outDir); % final outcomes directory creation (if this has not been created yet)

% running all the benchmarks can take several hours.
tic;
allBench(imgDir, gtDir, inDir, outDir)
toc;

plot_eval(outDir);