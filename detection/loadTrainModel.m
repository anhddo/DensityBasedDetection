function opts=loadTrainModel(datasetName)
%%loadTrainModel;
opts=allParameter(datasetName);
if exist(opts.dtsetOpts.pDenPath,'file')
    load(opts.dtsetOpts.pDenPath);opts.pDen=pDen;
end
if exist(opts.dtsetOpts.SvmModelPath,'file')
    load(opts.dtsetOpts.SvmModelPath);opts.model.svm=SVMModel;
end
if exist(opts.dtsetOpts.BetaPath,'file')
    load(opts.dtsetOpts.BetaPath);opts.model.BETA=BETA;
end