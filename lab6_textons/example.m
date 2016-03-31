
addpath('lib')
%clear all;close all;clc;
clear all;clc;

% create filter bank
[fb] = fbCreate;


% imagen de referencia para construir diccionario de textones
%im1=double(rgb2gray(imread('9_1_s.bmp')))/255;
%im2=double(rgb2gray(imread('6_1_s.bmp')))/255;
ims = cell(size(fb));
% numero de textones en diccionario
k = 20;
textonsf = [];
trainDir = dir('*1_s.bmp');

for j = 1: numel(trainDir),
    im = fbRun(fb,double(rgb2gray(imread(trainDir(j).name)))/255);
    [map,textons] = computeTextons(im,10);
    textonsf = [textonsf ; textons];
    
%     for i = 1:numel(fb),
%         ims{i} = [ims{i} im{i}];
%     end
end


% diccionario de textones
% [map,textons] = computeTextons(ims,k);
%figure;imshow(map,[]);colormap(jet);

D=dir('*.bmp');
% texton maps de dos nuevas imagenes
for i=1:numel(D),
    im2=double(rgb2gray(imread(D(i).name)))/255;
    tmap = assignTextons(fbRun(fb,im2),textonsf');
    
    % la distribucion de textones en la oveja deberia ser similar a la de la
    % imagen de referencia.
    figure(i + 4);subplot(1,2,1);imshow(tmap,[]);colormap(jet);
    subplot(1,2,2);bar(histc(tmap(:),1:k)/numel(tmap));
    drawnow;
end

