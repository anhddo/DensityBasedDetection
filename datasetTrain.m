function datasetTrain(dataset)
opts=allParameter(dataset);
densityTraining(opts);
trainSVMModel(opts);
plsTrain(opts)