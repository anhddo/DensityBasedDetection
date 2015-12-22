function opts=loadTrainModel(varargin)
%%loadTrainModel;
datasetName=varargin{1};
if nargin==2,opts=allParameter(datasetName,varargin{2});
else,opts=allParameter(datasetName);end;
if exist(opts.dtsetOpts.pDenPath,'file')
    load(opts.dtsetOpts.pDenPath);opts.pDen=pDen;
end
if exist(opts.dtsetOpts.SvmModelPath,'file')
    load(opts.dtsetOpts.SvmModelPath);opts.model.svm=SVMModel;
end
if exist(opts.dtsetOpts.BetaPath,'file')
    load(opts.dtsetOpts.BetaPath);opts.model.BETA=BETA;
end