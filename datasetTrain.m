function datasetTrain(dataset)
opts=allParameter(dataset);
% densityTraining(opts);
% [resultPath,timeResultPath]=densityDetection('densityVivo','vivo');
trainSVMModel(opts);
plsTrain(opts)