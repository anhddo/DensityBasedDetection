function [ftrs,denGts,ims]=genFtrAndDen(opts)
ims=createAllImForDenseTraining(opts);
    function ftrs=extractFeatureForTrainImg
        ftrs=cell(1,opts.pDen.nTrnIm);
        for i=1:opts.pDen.nTrnIm
            ftrs{i}=extractFeature(ims{i},opts);
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
if ~exist(fullfile(opts.dtsetOpts.datasetDir,'frames'),'dir'),createImageSequence;end;
ftrs=extractFeatureForTrainImg;
denGts=createDenseTrainImages(opts,ims);
end
