function [ftrs,denGts]=genFtrAndDen(opts)
% ims=createAllImForDenseTraining(opts);
    function ftrs=extractFeatureForTrainImg
        ftrs=cell(1,opts.pDen.nTrnIm);
        for i=1:opts.pDen.nTrnIm
            idx=opts.pDen.imIdx(i);
            ftrs{i}=extractFeature(getImForDensityPhase(idx,opts),opts);
        end
    end

    function createTempFolder
        tempFolder='temp';
        if ~exist(tempFolder,'dir')
            mkdir(tempFolder);
            delete(fullfile(tempFolder,'*.png'));
        end
    end
createTempFolder;
% if ~exist(fullfile(opts.dtsetOpts.datasetDir,'frames'),'dir'),createImageSequence;end;
ftrs=extractFeatureForTrainImg;
denGts=createDenseTrainImages(opts);
end
