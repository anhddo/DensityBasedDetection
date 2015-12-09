function opts=GUIinitData(datasetName)
opts=allParameter(datasetName);
if strcmp(datasetName,'mall')
    gui=struct('frameId',1801,'plotEstRange',35,'framestep',1);
elseif strcmp(datasetName,'vivo')
end
gui.timePerIm=[]; gui.denEst=[];
opts.gui=gui;
end

