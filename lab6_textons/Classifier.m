addpath('lib')
databasePath = '/home/jvalero/ArchivosWindows/Pasantia/Textons/data/textures/';% Where database is
clear all;close all;clc;

% create filter bank
[fb] = fbCreate;

% Create textons descriptors
textons = DatabaseDescTiTj( fb, databasePath , 1, 25);

% Create train dataset image descriptors
trainData = asignDesc( fb, databasePath , textons, 'train', true);

% Create test dataset image descriptors
testData = asignDesc( fb, databasePath , textons, 'test', true);

% Run the nearest neighbor classifier
classifNearNeig = nearestNeighborClassifier(trainData,testData);

% Run the random forest classifier
[model,classifRanFor] = randomForestClassifier( trainData,testData );

%% Evaluate nearest neighbor classification
    % Overall accuracy
confNearNeig = confusionmat(testData(:,201), classifNearNeig);
TPNN = sum(diag(confNearNeig));
overallAccuracyNN = TPNN / sum(sum(confNearNeig));

    % Texture category accuracy
textureCategAccNN = diag(confNearNeig)./sum(confNearNeig,2);

%% Evaluate random forest classification
    % Overall accuracy
confRanFor = confusionmat(testData(:,201), cellfun(@str2num,classifRanFor));
TPRF = sum (diag(confRanFor));
overallAccuracyRF = TPRF/sum(sum (confRanFor));

    % Texture category accuracy
textureCategAccRF = diag(confRanFor)./sum(confRanFor,2);

% T01 corteza 1
% T02 corteza 2
% T03 corteza 3
% T04 madera 1
% T05 madera 2
% T06 madera 3
% T07 agua 1
% T08 granito 1
% T09 mármol 1
% T10 piso 1
% T11 piso 2
% T12 guijarros 1
% T13 pared 1
% T14 ladrillo 1
% T15 ladrillo 2
% T16 vidrio 1
% T17 vidrio 2
% T18 alfombra 1
% T19 alfombra 2
% T20 tapicería 1
% T21 papel tapiz 1
% T22 pieles 1
% T23 tejido de punto 1
% T24 pana 1
% T25 tela escocesa 1
