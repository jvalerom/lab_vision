function [ classif ] = nearestNeighborClassifier( trainDataset,testDataset )
% function [ classif ] = nearestNeighbourClassifier( trainDataset,testDataset )
%
% First it creates a nearest neighbor classifier based on the training
% dataset provided and then uses it to predict the class of each descriptor
% in the test dataset provided using chi square distance as a similarity
% measure.
%
% Input:
%   trainDataset:	the trainin dataset tobe used for training the model.
%   Its last column will be used as the predictor one.
%   testDataset:	the test dataset tobe used for test the model.
%
% Output:
%   classif:        prediction vector for the provided test dataset.
%
% José Valero <ja.valero@uniandes.edu.co>
% March 2016
%


%% It is necessary to create the classifier model
    X = trainDataset(:,1:size(trainDataset,2) -1);
    Y = trainDataset(:,size(trainDataset,2));
    model = fitcknn(X,Y,'Distance',@chi2); % 'NumNeighbors' default value of 1 is used as it gets the nearest neighbor
    
%% Now, the classifier model already created is applied on test dataset
    testData = testDataset(:,1:size(trainDataset,2) -1);
    classif = predict(model,testData);
end
