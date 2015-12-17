function datasetTrain(varargin)
dataset=varargin{1};
if nargin==2
    args=varargin{2};
    opts=allParameter(dataset,args);
else
    opts=allParameter(dataset);
end
densityTraining(opts);
trainSVMModel(opts);
plsTrain(opts)