function [ model,classif ] = randomForestClassifier( trainDataset,testDataset )
% function [ model,classif ] = randomForestClassifier( trainDataset,testDataset )
%
% First it creates and trains a random forest classifier model based on the training
% dataset provided and then uses it to predict the class of each descriptor
% in the test dataset provided. The model bags 50 decision trees.
%
% Input:
%   trainDataset:	the trainin dataset tobe used for training the model. Its last column will be used as the predictor one.
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
    model = TreeBagger(50,X,Y);
    
%% Now, the classifier model already created is applied on test dataset
    testData = testDataset(:,1:size(trainDataset,2) -1);
    classif = model.predict(testData);
end
