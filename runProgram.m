initPath;
if ispc,
    trainFolder=fullfile('density','train');
    cd(trainFolder);
    if ~exist(fullfile('maxsubarray2D.mexw64'))
        mex maxsubarray2D.cpp;
    end
    cd(fullfile('..','..'));
end
datasetTrain('mall');
demoGUI;