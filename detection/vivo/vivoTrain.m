opts=allParameter('vivo');
pDenPath=fullfile(opts.dtsetOpts.matDir,'vivopDen.mat');
forestPath=fullfile(opts.dtsetOpts.matDir,'vivoForest.mat');
densityTraining(pDen,pDenPath,forestPath);
[resultPath,timeResultPath]=densityDetection('densityVivo','vivo');