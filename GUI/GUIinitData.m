function opts=GUIinitData(datasetName)
opts=loadTrainModel(datasetName);
if strcmp(datasetName,'mall')
    gui=struct('iFrame',1,'plotEstRange',35,'framestep',1);
elseif strcmp(datasetName,'vivo1')
    gui=struct('iFrame',1,'plotEstRange',10,'framestep',1);
elseif strcmp(datasetName,'crescent')
    gui=struct('iFrame',1,'plotEstRange',20,'framestep',1);
end
gui.timePerIm=[]; gui.denEst=[];
opts.gui=gui;

reRun=createOptsList(datasetName);
load(reRun{1}.resultOpts.resultFile);
opts.reRun.denPls=result;
load(reRun{2}.resultOpts.resultFile);
opts.reRun.pls=result;
load(reRun{1}.resultOpts.resultFile);
opts.reRun.denNoPls=result;
end

